-- Script to create a simple SMS sending procedure using Twilio API
CREATE OR REPLACE PROCEDURE send_sms_twilio (
    p_to_phone_no     IN VARCHAR2,
    p_message         IN VARCHAR2,
    p_account_sid     IN VARCHAR2 DEFAULT NULL,  -- Twilio Account SID
    p_auth_token      IN VARCHAR2 DEFAULT NULL,  -- Twilio Auth Token
    p_from_phone      IN VARCHAR2 DEFAULT NULL   -- Your Twilio phone number
)
IS
----------------------------------------------------------------------
-- PROCEDURE NAME    : send_sms_twilio
-- PURPOSE           : Send an SMS message using the Twilio API.
-- PARAMETERS        :  
--                     p_to_phone_no: The phone number to which the SMS will be sent.
--                     p_message: The message content to be sent as an SMS.
--                     p_account_sid: Your Twilio Account SID
--                     p_auth_token: Your Twilio Auth Token
--                     p_from_phone: Your Twilio phone number (with country code)
-- DESCRIPTION       :  
--                     This procedure constructs and sends an SMS message using the Twilio API.
--                     It constructs the request URL, sets the necessary request headers,
--                     and sends the POST request to the Twilio API.
-- ERROR HANDLING    : Logs any processing errors with basic error handling
-- Author            : General Purpose
-- Date              : 2025-12-26
----------------------------------------------------------------------
    -- Declare variables
    l_url               VARCHAR2(500);
    l_auth_header       VARCHAR2(1000);
    l_encoded_auth      VARCHAR2(1000);
    l_result            CLOB;
    l_error_msg         VARCHAR2(4000);

BEGIN
    -- Validate input parameters
    IF p_to_phone_no IS NULL OR p_message IS NULL OR p_account_sid IS NULL OR p_auth_token IS NULL OR p_from_phone IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'All parameters are required: phone number, message, account SID, auth token, and from phone number');
    END IF;

    -- Clear any existing cookies and headers to ensure clean state
    APEX_WEB_SERVICE.CLEAR_REQUEST_COOKIES;
    APEX_WEB_SERVICE.CLEAR_REQUEST_HEADERS;

    -- Construct the API URL
    l_url := 'https://api.twilio.com/2010-04-01/Accounts/' || p_account_sid || '/Messages.json';

    -- Create the Authorization header (Basic Auth with Account SID and Auth Token)
    l_encoded_auth := UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(p_account_sid || ':' || p_auth_token)));
    l_auth_header := 'Basic ' || l_encoded_auth;

    -- Set request headers
    APEX_WEB_SERVICE.G_REQUEST_HEADERS.DELETE();
    APEX_WEB_SERVICE.G_REQUEST_HEADERS(1).NAME := 'Authorization';
    APEX_WEB_SERVICE.G_REQUEST_HEADERS(1).VALUE := l_auth_header;
    APEX_WEB_SERVICE.G_REQUEST_HEADERS(2).NAME := 'Content-Type';
    APEX_WEB_SERVICE.G_REQUEST_HEADERS(2).VALUE := 'application/x-www-form-urlencoded';

    -- Make the POST request to Twilio API
    BEGIN
        l_result := APEX_WEB_SERVICE.MAKE_REST_REQUEST(
            p_url           => l_url,
            p_http_method   => 'POST',
            p_parm_name     => APEX_STRING.STRING_TO_TABLE('Body:To:From', ':'),
            p_parm_value    => APEX_STRING.STRING_TO_TABLE(p_message || ':' || p_to_phone_no || ':' || p_from_phone, ':'),
            p_transfer_timeout => 30
        );

        -- Check if the request was successful
        IF l_result IS NOT NULL AND INSTR(l_result, '"status":') > 0 THEN
            DBMS_OUTPUT.PUT_LINE('SMS sent successfully! Response: ' || SUBSTR(l_result, 1, 1000));
        ELSE
            RAISE_APPLICATION_ERROR(-20002, 'Failed to send SMS. Response: ' || NVL(l_result, 'No response'));
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            l_error_msg := 'Error sending SMS: ' || SQLERRM;
            DBMS_OUTPUT.PUT_LINE(l_error_msg);
            RAISE_APPLICATION_ERROR(-20003, l_error_msg);
    END;

    -- Clear headers after request
    APEX_WEB_SERVICE.CLEAR_REQUEST_COOKIES;
    APEX_WEB_SERVICE.CLEAR_REQUEST_HEADERS;

EXCEPTION
    WHEN OTHERS THEN
        -- Clear headers in case of error
        APEX_WEB_SERVICE.CLEAR_REQUEST_COOKIES;
        APEX_WEB_SERVICE.CLEAR_REQUEST_HEADERS;
        RAISE;
END send_sms_twilio;
/

-- Example of how to use the procedure
DECLARE
    l_account_sid VARCHAR2(100) := 'your_account_sid_here';      -- Replace with your actual Twilio Account SID
    l_auth_token  VARCHAR2(100) := 'your_auth_token_here';       -- Replace with your actual Twilio Auth Token
    l_from_phone  VARCHAR2(20)  := '+1234567890';                -- Replace with your actual Twilio phone number
BEGIN
    send_sms_twilio(
        p_to_phone_no => '+1987654321',                          -- Replace with the recipient's phone number
        p_message     => 'Hello from Oracle APEX & Twilio!',    -- Your message content
        p_account_sid => l_account_sid,
        p_auth_token  => l_auth_token,
        p_from_phone  => l_from_phone
    );
    
    DBMS_OUTPUT.PUT_LINE('SMS procedure completed successfully');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/