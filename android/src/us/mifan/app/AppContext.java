package us.mifan.app;

import java.util.Properties;
import java.util.UUID;

import us.mifan.app.AppConfig;
import us.mifan.app.api.ApiClient;
import net.thinkalways.util.StringUtils;
import android.app.Application;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Handler;
import android.util.Log;

/**
 * 全局参数类
 *
 * @author xie.hj
 * @version 0.1
 *
 */
public class AppContext extends Application {
	
	private static String TAG = AppContext.class.getSimpleName();
	
	public static final int PAGE_SIZE = 20;	//分页
	
	public static final String access_token = null;
	
	public void onCreate() {
		super.onCreate();
        //注册App异常崩溃处理器
        Thread.setDefaultUncaughtExceptionHandler(AppException.getAppExceptionHandler());
        
	}
	
	public PackageInfo getPackageInfo() {
		PackageInfo info = null;
		try { 
			info = getPackageManager().getPackageInfo(getPackageName(), 0);
		} catch (NameNotFoundException e) {
			Log.e(TAG, "出错了");
			e.printStackTrace(System.err);
		} 
		if(info == null) info = new PackageInfo();
		return info;
	}
	
	public String getAppId() {
		String uniqueID = getProperty(AppConfig.CONF_APP_UNIQUEID);
		if(StringUtils.isEmpty(uniqueID)){
			uniqueID = UUID.randomUUID().toString();
			setProperty(AppConfig.CONF_APP_UNIQUEID, uniqueID);
		}
		return uniqueID;
	}
	
	/**
	 * 用户注销
	 */
	public void Logout() {
		ApiClient.cleanCookie();
		this.cleanCookie();
		
	}
	
	/**
	 * 未登录或修改密码后的处理
	 */
	public Handler getUnLoginHandler() {
		return null;
	}
	
	/**
	 * 清除保存的缓存
	 */
	public void cleanCookie()
	{
		removeProperty(AppConfig.CONF_COOKIE);
	}
	
	public boolean containsProperty(String key){
		Properties props = getProperties();
		return props.containsKey(key);
	}
	
	public Properties getProperties(){
		return AppConfig.getAppConfig(this).get();
	}
	
	public void setProperty(String key,String value){
		AppConfig.getAppConfig(this).set(key, value);
	}

	public String getProperty(String key){
		return AppConfig.getAppConfig(this).get(key);
	}
	
	public void removeProperty(String...key){
		AppConfig.getAppConfig(this).remove(key);
	}
	
}
