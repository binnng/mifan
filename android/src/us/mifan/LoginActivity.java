package us.mifan;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;

import us.mifan.app.AppContext;
import us.mifan.app.AppException;
import us.mifan.app.api.ApiClient;
import us.mifan.app.bean.Result;
import us.mifan.app.bean.URLs;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.StrictMode;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class LoginActivity extends Activity {
	
	private final String TAG = LoginActivity.class.getSimpleName();

	private EditText usernameText;	//用户名
	private EditText passwordText;	//密码
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_login);
		/*
		if (android.os.Build.VERSION.SDK_INT > 9) {
		    StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
		    StrictMode.setThreadPolicy(policy);
		}
		*/
		usernameText = (EditText) this.findViewById(R.id.username);
		passwordText = (EditText) this.findViewById(R.id.password);
		Button login = (Button) this.findViewById(R.id.login);
		login.setOnClickListener(new LoginButtonClickListener());
	}
	
	private final class LoginButtonClickListener implements View.OnClickListener{
				
		@Override
		public void onClick(View v) {
			
			String username = usernameText.getText().toString().trim();
			String pwd = passwordText.getText().toString().trim();
			
			if(validate(username,pwd)){
				login(username, pwd);
			}
			
		}
		
		 private boolean validate(String username,String pwd) {  
	           
	            if (username.equals("")) {  
	            	Toast.makeText(getApplicationContext(),"邮箱是必填项！",Toast.LENGTH_LONG).show();
	                return false;  
	            }  
	           
	            if (pwd.equals("")) {  
	            	Toast.makeText(getApplicationContext(),"密码是必填项！",Toast.LENGTH_LONG).show();
	                return false;  
	            }  
	            
	            return true;  
	     }
		
		 private boolean login(final String username,final String pwd){
			
			final Handler handler = new Handler() {
				public void handleMessage(Message msg) {
					if(msg.what == 1){
						Result result = (Result) msg.obj;
						Toast.makeText(getApplicationContext(),result.getRet() + " , " + result.getMsg(),Toast.LENGTH_LONG).show();
					}else{
						Toast.makeText(getApplicationContext(),"登录出错",Toast.LENGTH_LONG).show();
					}
				}
			};
			
			new Thread(){
				public void run() {
					Message msg = Message.obtain();
					
					try {
						AppContext appContext = (AppContext)getApplication();
						String url = URLs.LOGIN_HTTP;
						Map<String,Object> params = new HashMap<String, Object>();
						params.put("user_email", username);
						params.put("user_password", pwd);						
						
						InputStream inputStream = ApiClient.http_post(appContext, url, params, null);
						
						Result result = Result.parse(inputStream);
												
						msg.what = 1;
						msg.obj = result;
						
					} catch (AppException e) {
						Log.e(TAG, "解析出错");
						msg.what = 0;
						msg.obj = e;
						e.printStackTrace();
					} catch (IOException e) {
						// TODO 自动生成的 catch 块
						msg.what = 0;
						msg.obj = e;
						e.printStackTrace();
					} catch (JSONException e) {
						// TODO 自动生成的 catch 块
						msg.what = 0;
						msg.obj = e;
						e.printStackTrace();
					} finally{
						handler.sendMessage(msg);
					}
				}						
				
			}.start();	
			
			return false;
			 
		 }
	}
}
