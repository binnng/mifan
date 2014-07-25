package us.mifan.app.api;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

import org.apache.commons.httpclient.DefaultHttpMethodRetryHandler;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.MultiThreadedHttpConnectionManager;
import org.apache.commons.httpclient.cookie.CookiePolicy;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.multipart.FilePart;
import org.apache.commons.httpclient.methods.multipart.MultipartRequestEntity;
import org.apache.commons.httpclient.methods.multipart.Part;
import org.apache.commons.httpclient.methods.multipart.StringPart;
import org.apache.commons.httpclient.params.HttpMethodParams;

import android.util.Log;
import us.mifan.app.AppContext;
import us.mifan.app.AppException;
import us.mifan.app.bean.URLs;

/**
 * API客户端接口：用于访问网络数据
 *
 * @author xie.hj
 *
 */
public class ApiClient {
	private static final String TAG = ApiClient.class.getSimpleName();
	private static final String ENCODE = "UTF-8";	//字符集
	
	private final static int TIMEOUT_CONNECTION = 20000;	//连接超时时间
	private final static int TIMEOUT_SOCKET = 20000;	//读数据超时时间
	private final static int RETRY_TIME = 3;
	
	private static String appCookie;
	private static String appUserAgent;
	
	public static void cleanCookie() {
		appCookie = "";
	}

	private static String getCookie(AppContext appContext) {
		if(appCookie == null || appCookie == "") {
			appCookie = appContext.getProperty("cookie");
		}
		return appCookie;
	}
	
	private static String getUserAgent(AppContext appContext) {
		if(appUserAgent == null || appUserAgent == "") {
			StringBuilder ua = new StringBuilder("mifan.us");
			ua.append('/'+appContext.getPackageInfo().versionName+'_'+appContext.getPackageInfo().versionCode);//App版本
			ua.append("/Android");//手机系统平台
			ua.append("/"+android.os.Build.VERSION.RELEASE);//手机系统版本
			ua.append("/"+android.os.Build.MODEL); //手机型号
			ua.append("/"+appContext.getAppId());//客户端唯一标识
			appUserAgent = ua.toString();
		}
		return appUserAgent;
	}
	
	private static HttpClient getHttpClient() {
        HttpClient httpClient = new HttpClient();
		// 设置 HttpClient 接收 Cookie,用与浏览器一样的策略
		httpClient.getParams().setCookiePolicy(CookiePolicy.BROWSER_COMPATIBILITY);
        // 设置 默认的超时重试处理策略
		httpClient.getParams().setParameter(HttpMethodParams.RETRY_HANDLER, new DefaultHttpMethodRetryHandler());
		httpClient.getHttpConnectionManager().getParams().setConnectionTimeout(TIMEOUT_CONNECTION);
		httpClient.getHttpConnectionManager().getParams().setSoTimeout(TIMEOUT_SOCKET);
		httpClient.getParams().setContentCharset(ENCODE);
		
		
		return httpClient;
	}
	
	private static GetMethod getHttpGet(String url, String cookie, String userAgent) {
		GetMethod httpGet = new GetMethod(url);
		// 设置 请求超时时间
		httpGet.getParams().setSoTimeout(TIMEOUT_SOCKET);
		httpGet.setRequestHeader("Host", URLs.HOST);
		httpGet.setRequestHeader("Connection","Keep-Alive");
		httpGet.setRequestHeader("Cookie", cookie);
		httpGet.setRequestHeader("User-Agent", userAgent);
		return httpGet;
	}
	
	private static PostMethod getHttpPost(String url, String cookie, String userAgent) {
		PostMethod httpPost = new PostMethod(url);
		// 设置 请求超时时间
		httpPost.getParams().setSoTimeout(TIMEOUT_SOCKET);
		httpPost.setRequestHeader("Host", URLs.HOST);
		httpPost.setRequestHeader("Connection","Keep-Alive");
		httpPost.setRequestHeader("Cookie", cookie);
		httpPost.setRequestHeader("User-Agent", userAgent);
		return httpPost;
	}
	
	private static String _MakeURL(String p_url, Map<String, Object> params) {
		StringBuilder url = new StringBuilder(p_url);
		if(url.indexOf("?")<0)
			url.append('?');

		for(String name : params.keySet()){
			url.append('&');
			url.append(name);
			url.append('=');
			url.append(String.valueOf(params.get(name)));
			//不做URLEncoder处理
			//url.append(URLEncoder.encode(String.valueOf(params.get(name)), UTF_8));
		}

		return url.toString().replace("?&", "?");
	}
	
	public static InputStream http_get(AppContext appContext, String url) throws AppException{
		
		String cookie = getCookie(appContext);
		String userAgent = getUserAgent(appContext);
		
		HttpClient httpClient = null;
		GetMethod httpGet = null;

		InputStream responseBody = null;
		int time = 0;
		
		do{				
			try {
				httpClient = getHttpClient();
				httpGet = getHttpGet(url, cookie, userAgent);		
				int statusCode = httpClient.executeMethod(httpGet);
				
				if (statusCode != HttpStatus.SC_OK) {
					throw AppException.http(statusCode);
				}
				responseBody = httpGet.getResponseBodyAsStream();
				break;
			} catch (HttpException e) {
				time++;
				if(time < RETRY_TIME) {
					try {
						Thread.sleep(1000);
					} catch (InterruptedException e1) {} 
					continue;
				}
				// 发生致命的异常，可能是协议不对或者返回的内容有问题,重试三次
				e.printStackTrace();
				throw AppException.http(e);
			} catch (IOException e) {
				time++;
				if(time < RETRY_TIME) {
					try {
						Thread.sleep(1000);
					} catch (InterruptedException e1) {} 
					continue;
				}
				// 发生网络异常
				e.printStackTrace();
				throw AppException.network(e);
			}finally{
				//httpGet.releaseConnection();
				//httpClient = null;
				//((MultiThreadedHttpConnectionManager) httpClient.getHttpConnectionManager()).shutdown();
				
			}			
			
		}while(time<RETRY_TIME);
		
		return responseBody;
		
	}
	
	public static InputStream http_post(AppContext appContext,String url,Map<String, Object> params,Map<String,File> files) throws AppException{
		
		String cookie = getCookie(appContext);
		String userAgent = getUserAgent(appContext);
		
		HttpClient httpClient = null;
		PostMethod httpPost = null;
		InputStream responseBody = null;
		int time = 0;
		int i = 0;
		
		//参数处理
		int length = (params == null ? 0 : params.size()) + (files == null ? 0 : files.size());
		Part[] parts = new Part[length];
		if(null != params){
			for(String name : params.keySet()){
	        	parts[i++] = new StringPart(name, String.valueOf(params.get(name)), ENCODE);
	        }
		}
		
		if(null!=files){
			for(String file : files.keySet()){
				try {
					parts[i++] = new FilePart(file, files.get(file));
				} catch (FileNotFoundException e) {
					Log.e(TAG, "http_post==>文件不存在!");
					e.printStackTrace();
				}
			}
		}
		
		do{			
			try {
				httpClient = getHttpClient();
				httpPost = getHttpPost(url, cookie, userAgent);
				httpPost.setRequestEntity(new MultipartRequestEntity(parts,httpPost.getParams()));
				int statusCode = httpClient.executeMethod(httpPost);
				if (statusCode != HttpStatus.SC_OK) {
					throw AppException.http(statusCode);
				}
				
				responseBody = httpPost.getResponseBodyAsStream();
				break;
			} catch (HttpException e) {
				time++;
				if(time < RETRY_TIME) {
					try {
						Thread.sleep(1000);
					} catch (InterruptedException e1) {} 
					continue;
				}
				// 发生致命的异常，可能是协议不对或者返回的内容有问题,重试三次
				e.printStackTrace();
				throw AppException.http(e);
			} catch (IOException e) {
				time++;
				if(time < RETRY_TIME) {
					try {
						Thread.sleep(1000);
					} catch (InterruptedException e1) {} 
					continue;
				}
				// 发生网络异常
				e.printStackTrace();
				throw AppException.network(e);
			}
			
			
		}while(time<RETRY_TIME);
		
		
		return responseBody;
		
	}
	
}
