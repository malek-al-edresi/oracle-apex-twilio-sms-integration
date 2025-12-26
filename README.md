# Oracle APEX + Twilio SMS Integration

This project demonstrates how to integrate **Twilio SMS API** with **Oracle APEX / Oracle Database (PL/SQL)** to send SMS messages programmatically.
It includes example SQL scripts, a stored procedure for sending SMS, configuration steps, and sample usage.

---
![procedure](screenshot/temp.jpg) 

| Procedure Code | Run Preview |
|----------------|-------------|
| ![procedure](screenshot/procedure.png) | ![message](screenshot/message.jpg) |

---


## Features

* Send SMS directly from Oracle Database using Twilio API
* Ready-to-use `PL/SQL` procedure for message sending
* Works with **Oracle APEX** and **Autonomous Database**
* Simple configuration & customizable message body
* Example SQL script included
* No external configuration table dependency
* Easy to use with direct parameter passing

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

### 1. Get Twilio Credentials

From Twilio Console:

```
ACCOUNT_SID
AUTH_TOKEN
TWILIO_PHONE_NUMBER
```

---

### 2. Create Procedure Inside Oracle

Import `script.sql` or create manually.

Example structure:

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

You may call the procedure after button click or dynamic action:

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

* Do not publish **AUTH_TOKEN** publicly
* Use **APEX Credential Store / Vault** for production
* Ensure network access to `api.twilio.com`
* Consider storing credentials in database tables or vault for production use
* Validate phone numbers and message content before sending

---

## About Me

**Malek Mohammed**  
*Oracle APEX Engineer, PL/SQL Specialist, Database & Cloud Developer*

LinkedIn: [Malek_Al_Edresi](https://linkedin.com/in/Malek_Al_Edresi)  
GitHub: [malek-al-edresi](https://github.com/malek-al-edresi)  
Email: malek.m.edresi@gmail.com