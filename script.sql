-- script for create proceudre sned sms by twilio api

create or replace procedure send_sms (
    p_to_phone_no     in varchar2,
    p_msg             in clob
)
is
---------------------------------------------------------------------- 
-- PROCEDURE NAME    : send_sms
-- PURPOSE           : Send an SMS message using the UltraMsg API.
-- PARAMETERS        :  
--                     p_to_phone_no: The phone number to which the SMS will be sent.
--                     p_msg: The message content to be sent as an SMS.
-- DESCRIPTION       :  
--                     This procedure constructs and sends an SMS message using the UltraMsg API.
--                     It retrieves necessary API configuration details, constructs the request URL,
--                     sets the necessary request headers, and sends the POST request to the Twilio API.
-- ERROR HANDLING    : Logs any processing errors to ERROR_LOG_PKG_SYSTEM_ALL  
--                     with source identification and user context  
-- Author            : ENG.Malek Mohammed Al-edresi  
-- Date              : 2025-12-24  
-- Version           : 1.0  
----------------------------------------------------------------------
    -- Declare variables to hold API configuration details
    l_get_confgration MANAG_SYS_SEC_L_SETTING_API_SERVICES%ROWTYPE;

    -- Declare variables to hold API credentials and configuration details
    l_account_sid           varchar2(255);
    l_auth_token            varchar2(255); 
    l_auth_auth_type        varchar2(10); 
    l_auth_str              varchar2(500);
    l_twilio_host           varchar2(30); 
    l_twilio_api_version    varchar2(20);
    l_url_api               varchar2(100);
    l_defult_sender_phone   varchar2(20);
    l_country_code          varchar2(20);
    l_full_phone_number     varchar2(20);


    -- Declare variable to hold the constructed URL
    l_method_url            varchar2(300);

    -- Declare variable to hold the result of the API call
    l_result                clob;

    -- Declare debug template for logging
    l_debug_template        varchar2(4000) := 'twilio.send_sms_msg %0 %1 %2 %3 %4 %5 %6 %7';

    -- Declare error handling variables
    l_error_info     file_processing_error_type := file_processing_error_type(NULL, NULL, 'PROCESSING', NVL(v('APP_USER'), 'SYSTEM')); 

begin
    -- Initialize all variables to ensure clean state
    l_account_sid := null;
    l_auth_token := null;
    l_auth_auth_type := null;
    l_auth_str := null;
    l_twilio_host := null;
    l_twilio_api_version := null;
    l_url_api := null;
    l_defult_sender_phone := null;
    l_country_code := null;
    l_full_phone_number := null;
    l_method_url := null;
    l_result :=  EMPTY_CLOB();


    -- Clear any existing cookies and headers to ensure clean state
    apex_web_service.clear_request_cookies;
    apex_web_service.clear_request_headers;

    -- Enable debug logging and log the start of the procedure
    apex_debug.enable();

    -- Log the input parameters
    apex_debug.message(l_debug_template, 'START', 'p_to_phone_no', p_to_phone_no, 'l_defult_sender_phone', l_defult_sender_phone, 'p_msg', p_msg);

    -- Retrieve API configuration
    l_get_confgration:= GET_API_CONFIG ( p_service_name => 'TWILIO_SMS_SERVICE');


    -- Handle any exceptions that may occur during configuration retrieval
    BEGIN
        -- Extract and trim configuration values
        l_account_sid         := TRIM(l_get_confgration.ACCOUNT_SID);
        l_auth_token          := TRIM(l_get_confgration.API_KEY); -- Your actual Auth Token
        l_auth_auth_type      := TRIM(l_get_confgration.AUTH_TYPE);
        l_auth_str            := l_auth_auth_type || ' ' || l_auth_token;
        l_twilio_host         := TRIM(l_get_confgration.API_HOST); -- Removed extra spaces
        l_twilio_api_version  := TRIM(l_get_confgration.SERVICE_VERSION);
        l_url_api             := TRIM(l_get_confgration.API_URL);
        l_defult_sender_phone := TRIM(l_get_confgration.DEFAULT_SENDER_PHONE);
        l_country_code        := TRIM(l_get_confgration.CODE_COUNTRY_CALL);

        -- Construct the full phone number with country code
        l_full_phone_number   := l_country_code || p_to_phone_no;


        -- Construct the full URL for the Twilio API request
        l_method_url          := l_twilio_host || '/' || l_twilio_api_version ||'/Accounts/'|| l_account_sid || l_url_api;

        apex_debug.message(l_debug_template, 'l_method_url', l_method_url);

     EXCEPTION
        WHEN OTHERS THEN
            l_error_info.error_message := 'Error for get data form table MANAG_SYS_SEC_L_SETTING_API_SERVICES' || SQLERRM; 
            l_error_info.error_source := 'GET_FILE_AS_BASE64 - Main Process';  
            l_error_info.processing_status := 'ERROR'; 
            ERROR_LOG_PKG_SYSTEM_ALL.INSERT_FUNCTIONS_SEC_LOG (  
                l_error_info.error_message,  
                l_error_info.error_source,  
                l_error_info.user_name  
            );  
    END;

    -- Make the POST request to the Twilio API
    BEGIN
       -- Clear any existing headers
        apex_web_service.g_request_headers.delete();

        -- Set request headers for application/x-www-form-urlencoded and basic auth
        apex_web_service.g_request_headers(1).name  := 'Content-Type';
        apex_web_service.g_request_headers(1).value := 'application/x-www-form-urlencoded';
        apex_web_service.g_request_headers(2).name  := 'Authorization';
        apex_web_service.g_request_headers(2).value := l_auth_str;

        -- Log the constructed URL and parameters
        apex_debug.message(l_debug_template, 'l_method_url', l_method_url);
        apex_debug.message(l_debug_template, 'p_msg', p_msg);
        apex_debug.message(l_debug_template, 'l_defult_sender_phone', l_defult_sender_phone);

        -- Make the POST request to Twilio API
        l_result := apex_web_service.make_rest_request (
            p_url           => l_method_url,
            p_http_method   => 'POST',
            p_parm_name     => apex_string.string_to_table('Body:To:From', ':'),
            p_parm_value    => apex_string.string_to_table(p_msg || ':' || l_full_phone_number ||':'|| l_defult_sender_phone, ':'),
            p_transfer_timeout => 30
        );
    EXCEPTION
        WHEN OTHERS THEN
            l_error_info.error_message := 'Error during Twilio API request' || SQLERRM; 
            l_error_info.error_source := 'send_sms - Twilio API Request';  
            l_error_info.processing_status := 'ERROR'; 
            ERROR_LOG_PKG_SYSTEM_ALL.INSERT_FUNCTIONS_SEC_LOG (  
                l_error_info.error_message,  
                l_error_info.error_source,  
                l_error_info.user_name  
            );

        -- Clear any existing cookies and headers to ensure clean state
        apex_web_service.clear_request_cookies;
        apex_web_service.clear_request_headers;
    END;

    -- Clear any existing cookies and headers to ensure clean state
    apex_web_service.clear_request_cookies;
    apex_web_service.clear_request_headers;

    -- Log the result of the API call
    apex_debug.message(l_debug_template, 'l_result', l_result);
    apex_debug.message(l_debug_template, 'END');
    apex_debug.disable();

exception
    when others then
        -- Log any exceptions that occur during the procedure execution
        l_error_info.error_message := 'Error in send_sms procedure' || SQLERRM; 
        l_error_info.error_source := 'send_sms - Main Process';  
        l_error_info.processing_status := 'ERROR'; 
        ERROR_LOG_PKG_SYSTEM_ALL.INSERT_FUNCTIONS_SEC_LOG (  
            l_error_info.error_message,  
            l_error_info.error_source,  
            l_error_info.user_name  
        );

        apex_debug.error(l_debug_template, 'Unhandled Exception ', sqlerrm);

        -- Clear any existing cookies and headers to ensure clean state
        apex_web_service.clear_request_cookies;
        apex_web_service.clear_request_headers;

        -- Log the error using your centralized error logging mechanism
        null;
end send_sms;
/

