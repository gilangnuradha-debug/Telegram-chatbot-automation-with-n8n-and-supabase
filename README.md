# Telegram Chatbot Automation with n8n and Supabase — SGA Management

This project automates **Student Government Association (SGA)** data management using a Telegram chatbot, orchestrated with [n8n](https://n8n.io/) workflows and [Supabase](https://supabase.com/) PostgreSQL as the backend database.

The system enables:

- Automated event and activity management
- Membership and division tracking
- Attendance (presensi) logging
- Financial workflows for student activities (pengajuan dana, kas SGA)

---

## Table of Contents

1. [Features](#features)
2. [Database Schema](#database-schema)
3. [Setup Instructions](#setup-instructions)
4. [Usage](#usage)
5. [Database: Full Reset Warning](#database-full-reset-warning)
6. [Troubleshooting](#troubleshooting)
7. [License](#license)
8. [Author](#author)
9. [References](#references)

---

## Features

- **Telegram Bot integration** for SGA communication, attendance, and event queries
- **n8n workflow automation** for data entry, reporting, reminders, and multi-step business logic
- **Normalized PostgreSQL schema** (via Supabase) optimized for SGA operations: proposals, finance, activities, and attendance
- **Full schema and seed script** (`sga_full_reset_schema_seed.sql`) for reproducible database initialization

---

## Database Schema

See [`sga_full_reset_schema_seed.sql`](./sga_full_reset_schema_seed.sql) for the complete schema and example seed data.

### Main Tables

| Table Name       | Description                                                   |
|------------------|---------------------------------------------------------------|
| `periode`        | Academic periods / years (e.g., 2023/2024)                    |
| `jabatan`        | SGA positions and roles (e.g., Ketua, Sekretaris)             |
| `divisi`         | SGA divisions / departments (e.g., Akademik, Keuangan)        |
| `mahasiswa`      | Registered student members with contact and identity info     |
| `kepengurusan`   | SGA management structure: maps students to positions/divisions |
| `proker`         | Work programs (Program Kerja) belonging to each division      |
| `kegiatan`       | Events and activities that are instances of a work program    |
| `pengajuan_dana` | Activity fund proposals submitted for approval                |
| `kas_sga`        | SGA cash flow ledger tracking income and expenses             |
| `presensi`       | Attendance logs per student per event                         |

### Entity Relationship Overview

- Each **`kepengurusan`** ties a `mahasiswa` (student) to a `jabatan` (role), `divisi` (division), and `periode` (academic period).
- **`proker`** (work programs) belong to a `divisi`.
- **`kegiatan`** (events/activities) are instances under a `proker`.
- **`presensi`** logs attendance by `mahasiswa` for each `kegiatan`.
- **`pengajuan_dana`** and **`kas_sga`** handle finances linked to activities and members.

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/gilangnuradha-debug/Telegram-chatbot-automation-with-n8n-and-supabase.git
cd Telegram-chatbot-automation-with-n8n-and-supabase
```

### 2. Supabase Database Setup

1. Create a new project at [supabase.com](https://supabase.com/).
2. Open the **SQL Editor** in your Supabase dashboard.
3. Copy the contents of [`sga_full_reset_schema_seed.sql`](./sga_full_reset_schema_seed.sql) and run it.

> ⚠️ **Warning:** See the [Database: Full Reset Warning](#database-full-reset-warning) section before running.

4. Note your project's **Database URL**, **anon/public key**, and **service_role key** from *Settings → API*.

### 3. n8n Workflow Configuration

1. Deploy [n8n](https://docs.n8n.io/) — either self-hosted (Docker recommended) or via [n8n Cloud](https://app.n8n.io/).
2. In n8n, create or import workflows that connect Telegram triggers to Supabase nodes.
3. Add the following credentials in n8n (*Settings → Credentials*):
   - **Supabase**: your project URL and service role/anon key
   - **Telegram Bot API**: your bot token (see step 4)

### 4. Telegram Bot Setup

1. Open Telegram and start a chat with [@BotFather](https://t.me/BotFather).
2. Create a new bot with `/newbot` and follow the prompts.
3. Copy the generated **Bot Token**.
4. In n8n, add a *Telegram* credential and paste the token.
5. Set up a **Telegram Trigger** node in your workflow to receive messages from the bot.

### 5. Environment / Credentials Configuration

Store all sensitive values using n8n's built-in credential manager or environment variables:

| Variable / Credential          | Description                           |
|--------------------------------|---------------------------------------|
| `SUPABASE_URL`                 | Your Supabase project URL             |
| `SUPABASE_ANON_KEY`            | Supabase anonymous/public API key     |
| `SUPABASE_SERVICE_ROLE_KEY`    | Supabase service role key (server-side) |
| `TELEGRAM_BOT_TOKEN`           | Token from BotFather                  |

Do **not** commit secrets to version control.

---

## Usage

Use the Telegram bot to interact with the SGA system for common scenarios:

| Scenario                         | Description                                                      |
|----------------------------------|------------------------------------------------------------------|
| **Attendance / Presensi**        | Members send a command to mark attendance at a specific event    |
| **Activity Proposals**           | Submit or review `pengajuan_dana` entries for upcoming events    |
| **Finance Checks**               | Query current `kas_sga` balance or recent transactions           |
| **Event Information**            | Ask about upcoming `kegiatan` or work program (`proker`) details |
| **Automation / Reminders**       | n8n schedules automatic reminders and status updates via bot     |

---

## Database: Full Reset Warning

The script [`sga_full_reset_schema_seed.sql`](./sga_full_reset_schema_seed.sql) performs the following in order:

1. **Drops all existing tables** (in reverse dependency order to respect foreign keys)
2. **Creates all tables** (in dependency order)
3. **Inserts seed data** covering:
   - Academic periods, divisions, positions
   - Student records and management assignments
   - Work programs, events, financial entries, and attendance records

> ⚠️ **Running this script will permanently erase all existing data in the affected tables.**
> Use it only in development/testing environments or when a complete database reset is intentional.

---

## Troubleshooting

**Workflows fail to trigger or connect**
- Verify your Supabase URL and API keys are correctly entered in n8n credentials.
- Check that the Telegram Bot Token is valid and the bot is not blocked.
- Ensure n8n can reach the internet (no firewall blocking Telegram or Supabase endpoints).

**Database errors on schema initialization**
- Make sure you are running the SQL script in the Supabase **SQL Editor** with sufficient privileges.
- If tables already exist, the script will drop and recreate them — ensure you have a backup if needed.

**Bot does not respond**
- Confirm the Telegram Trigger node in n8n is active and the workflow is enabled.
- Check n8n execution logs (*Executions* tab) for error details.
- Verify the bot is added to the correct chat/group if using group mode.

**Data not appearing after actions**
- Check n8n node outputs for Supabase errors (e.g., RLS policy violations).
- Ensure Row Level Security (RLS) policies in Supabase allow the operations your workflow performs.

---

## License

This project is licensed under the **MIT License**.  
See the [LICENSE](./LICENSE) file for details.

---

## Author

- **gilangnuradha-debug** — [github.com/gilangnuradha-debug](https://github.com/gilangnuradha-debug)

---

## References

- [Supabase Documentation](https://supabase.com/docs)
- [n8n Documentation](https://docs.n8n.io/)
- [Telegram Bots API](https://core.telegram.org/bots/api)
- [BotFather](https://core.telegram.org/bots#botfather)
