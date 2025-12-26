# Oracle APEX + Twilio SMS Integration

This project demonstrates how to integrate **Twilio SMS API** with **Oracle APEX / Oracle Database (PL/SQL)** to send SMS messages programmatically.
It includes example SQL scripts, a stored procedure for sending SMS, configuration steps, and sample usage.

---

## Features

* Send SMS directly from Oracle Database using Twilio API
* Ready-to-use `PL/SQL` procedure for message sending
* Works with **Oracle APEX** and **Autonomous Database**
* Simple configuration & customizable message body
* Example SQL script included

---

## Project Structure

```
oracle-apex-twilio-sms-integration/
├── README.md                     # Documentation
├── script.sql                    # Twilio SMS procedure + test example
└── screenshot/
    └── procedure.png             # Screenshot of PL/SQL procedure
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
    p_to_phone_no in varchar2,
    p_message     in varchar2
) is
    ...
end;
/
```

---

### 3. Test SMS Sending

```sql
BEGIN
    send_sms_twilio(
        p_to_phone_no => '+1234567890',
        p_message     => 'Hello from Oracle APEX & Twilio!'
    );
END;
/
```

---

## APEX Integration Example

You may call the procedure after button click or dynamic action:

```plsql
send_sms_twilio(:P0_PHONE, :P0_MESSAGE);
```

---

## Security Notes

* Do not publish **AUTH_TOKEN** publicly
* Use **APEX Credential Store / Vault** for production
* Ensure network access to `api.twilio.com`

---

## Screenshot

| Procedure Preview                      |
| -------------------------------------- |
| ![procedure](screenshot/procedure.png) |

---

## About Me

**Malek Mohammed Al-Edresi** (مالك محمد الادريسي)  
*Oracle APEX Engineer, PL/SQL Specialist, Database & Cloud Developer*

### Professional Profile
- **Current Role**: Oracle APEX Engineer & PL/SQL Specialist
- **Specializations**: Database Architecture, RESTful APIs, Cloud Development (OCI)
- **Professional Title**: ENG. Malek Mohammed A
- **Industry**: Healthcare IT Solutions & Enterprise Systems

### Healthcare & Medical Systems
- **Primary Role**: Radiology Technician (فني أشعة) at عيادة العظام (Orthopedic Clinic)
- **Healthcare Systems**: Built comprehensive Medical Center System with 150+ APEX pages, 120+ database tables
- **Special Projects**: Developing health website for Multiple Sclerosis patients (IST224 Fall 2025 final project)
- **Personal Mission**: Improving lives of MS patients through technology, inspired by mother's MS diagnosis

### Technical Expertise
- **Core Technologies**: Oracle APEX, PL/SQL, Database Architecture, RESTful APIs
- **Frontend**: HTML, CSS, JavaScript, Flutter, Dart
- **Cloud Platforms**: Oracle Cloud Infrastructure (OCI), Autonomous Database
- **Integration**: JasperReports, Twilio API, SMS Notification Systems, CI/CD Pipelines

### Certifications
- Oracle APEX Developer Professional
- Oracle Cloud Infrastructure (OCI)
- Oracle Autonomous Database
- Oracle Cloud AI
- MySQL HeatWave
- OCP, OCA

### Contact Information
- **LinkedIn**: [Malek_Al_Edresi](https://linkedin.com/in/Malek_Al_Edresi)
- **GitHub**: [malek-al-edresi](https://github.com/malek-al-edresi)
- **Email**: malek.m.edresi@gmail.com
- **Phone**: +967778888730

### Education & Projects
- **Current Focus**: IST224 Fall 2025 - Health website for Multiple Sclerosis patients
- **Key Achievements**: Migrated Oracle Forms 6i to APEX 24.x with 40% efficiency improvement
- **Enterprise Experience**: Full Medical Center System, secure mobile apps, multi-layer architectures
- **Specialization**: Symptom tracking, medication reminders, health management systems

### Language Skills
- **Arabic**: Native speaker
- **English**: B2 level proficiency

### Professional Attributes
- Problem-solving & Security-driven development
- Agile delivery & Performance optimization
- Bilingual communication capabilities
- Healthcare IT domain expertise

### Notable Projects
- **AL-MALIK MEDICAL SYSTEM®**: Complete medical center solution
- **Twilio Integration**: SMS notification systems for medical appointments
- **Cloud Migration**: Autonomous Database implementations on OCI
- **Mobile Development**: Flutter applications with Oracle backend integration

---

*Developed with passion for healthcare innovation and database excellence*  
**© AL-MALIK MEDICAL SYSTEM®**