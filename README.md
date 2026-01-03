# Oracle APEX + Twilio SMS Integration

This project demonstrates how to integrate the **Twilio SMS API** with **Oracle APEX** and **Oracle Database (PL/SQL)** to send SMS messages programmatically. It provides a production-ready PL/SQL stored procedure, example SQL scripts, configuration guidance, and sample usage patterns for seamless SMS integration.

---
![procedure](screenshot/temp.jpg) 

| Procedure Code | Run Preview |
|----------------|-------------|
| ![procedure](screenshot/procedure.png) | ![message](screenshot/message.jpg) |

---


## Features

* Send SMS messages directly from Oracle Database using the Twilio API
* Production-ready PL/SQL stored procedure for SMS delivery
* Compatible with **Oracle APEX** and **Oracle Autonomous Database**
* Simple configuration with customizable message content
* Complete example SQL scripts included
* No external configuration table dependencies
* Straightforward parameter-based interface

---

## Project Structure

```
oracle-apex-twilio-sms-integration/
├── README.md                     # Documentation
├── script.sql                    # Twilio SMS procedure + test example
└── screenshot/
    └── procedure.png             # Screenshot of PL/SQL procedure
    └── message.jpg               # Screenshot of message output
```

---

## Requirements

| Component          | Version                             |
| ------------------ | ----------------------------------- |
| Oracle Database    | 12c or higher (19c recommended)     |
| Oracle APEX        | Optional (for UI integration)       |
| Twilio Account     | With API Credentials                |
| Network ACL/Wallet | Required for HTTPS outbound request |

---

## Setup Instructions

### 1. Obtain Twilio Credentials

Retrieve the following credentials from your Twilio Console:

```
ACCOUNT_SID
AUTH_TOKEN
TWILIO_PHONE_NUMBER
```

---

### 2. Create the PL/SQL Procedure

Import the provided `script.sql` file into your Oracle Database, or create the procedure manually.

Procedure structure:

```sql
create or replace procedure send_sms_twilio(
    p_to_phone_no IN VARCHAR2,
    p_message     IN VARCHAR2,
    p_account_sid IN VARCHAR2,
    p_auth_token  IN VARCHAR2,
    p_from_phone  IN VARCHAR2
) is
    ...
end;
/
```

---

### 3. Test SMS Sending

```sql
DECLARE
    l_account_sid VARCHAR2(100) := 'your_account_sid_here';
    l_auth_token  VARCHAR2(100) := 'your_auth_token_here';
    l_from_phone  VARCHAR2(20)  := '+1234567890';
BEGIN
    send_sms_twilio(
        p_to_phone_no => '+1987654321',
        p_message     => 'Hello from Oracle APEX & Twilio!',
        p_account_sid => l_account_sid,
        p_auth_token  => l_auth_token,
        p_from_phone  => l_from_phone
    );
END;
/
```

---

## APEX Integration Example

You can invoke the procedure from an APEX button click or dynamic action:

```plsql
DECLARE
    l_account_sid VARCHAR2(100) := 'your_account_sid_here';
    l_auth_token  VARCHAR2(100) := 'your_auth_token_here';
    l_from_phone  VARCHAR2(20)  := '+1234567890';
BEGIN
    send_sms_twilio(:P0_PHONE, :P0_MESSAGE, l_account_sid, l_auth_token, l_from_phone);
END;
/
```

---

## Security Notes

* **Never** expose your **AUTH_TOKEN** in public repositories or client-side code
* Use **Oracle APEX Credential Store** or a secure vault solution for production deployments
* Ensure your Oracle Database has network access to `api.twilio.com` (configure ACLs as needed)
* Store credentials securely using encrypted database tables or external vault services
* Always validate phone numbers and message content before sending to prevent abuse

---

## About Me

**Malek Mohammed**  
*Oracle APEX Engineer, PL/SQL Specialist, Database & Cloud Developer*

LinkedIn: [Malek_Al_Edresi](https://linkedin.com/in/Malek_Al_Edresi)  
GitHub: [malek-al-edresi](https://github.com/malek-al-edresi)  
Email: malek.m.edresi@gmail.com

---

## License

This project is licensed under the Apache License 2.0.