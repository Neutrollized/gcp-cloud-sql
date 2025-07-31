# GCP Cloud SQL

[Cloud SQL documentation](https://cloud.google.com/sql/docs/introduction)

Deploying GCP Cloud SQL with Terraform.  Learn about the different configuration, security, and connectivity options.  I don't focus on a lot of the enterprise-level settings, and is mostly aimed at educating developers who wants/needs to spin up a SQL database instance for development or testing purposes.

Currently only for MySQL and PostgreSQL (I don't know enough about SQL Server to make usage or configuration recommendations -- sorry, Microsoft)

Core resources used:
- [Cloud SQL DB Instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance)
- [Cloud SQL Database](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database)
- [Cloud SQL User](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user)
- [Secret Manager Secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret)
- [Secret Manager Secret Version](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version)
- [Ephemeral Random Password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/ephemeral-resources/password)


## Database Tiers
This varies depending on the edition you're using, but *ENTERPRISE_PLUS* will have have more machine sizing requirements and tiers compared to *ENTERPRISE*.  As this is a "learning" deployment, I'm focused more on the different database configurations, but if you want to see the full list of available in your region, run:
```
gcloud sql tiers list --filter=AVAILABLE_REGIONS=[YOUR_REGION_HERE]
```

**RECOMMENDED**: Although `f1-micro` works okay (it's the current default `machine_type`), I *highly* recommend starting out with the `g1-small` for a better overall experience. The `f1-micro` takes quite a bit longer to provision due to how little memory it has. I think the `g1-small` strikes a good balance between usability and cost, but if you don't mind waiting 3-4x longer for the `f1-micro`, then by all means :)


## Database Flags
Database flags can be used to further tune your database instance by adjusting server-specific parameters and options.

- [MySQL supported flags](https://cloud.google.com/sql/docs/mysql/flags#list-flags-mysql)
- [Postgres supported flags](https://cloud.google.com/sql/docs/postgres/flags#list-flags-postgres)


## Connected to Cloud SQL
### Cloud SQL Auth Proxy
Unless there's some reason why you can't, `cloud-sql-proxy` is probably the best way to connect to your Cloud SQL instance. I installed `cloud-sql-proxy` via Google Cloud SDK:
```
gcloud components install cloud-sql-proxy
```

**IMPORTANT**: If you have an existing `cloud_sql_proxy` (with underscores) in your path, that's v1, while `cloud-sql-proxy` (with dashes) is v2

You use `cloud-sql-proxy` to securely connect to your instance via the instance connection name (format: `PROJECT_ID:REGION_NAME:INSTANCE_NAME`). It will handle the authorization and encryption for you and all you have to do is connect to 127.0.0.1 as the database host and authenticate!


## Private Service Connect
### Direct (IP)
To connect directly to the PSC endpoint IP, make sure `connector_enforcement = "NOT_REQUIRED"` 

### Direct (DNS name)
To connect directly via DNS name, you need to create a [(Private) DNS Managed Zone](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) and [DNS Record Set ("A" record)](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set)

**IMPORTANT**: you will also need the DNS zone and record if you wish to use Cloud SQL Auth Proxy


### MySQL connection troubleshooting
#### MySQL Client v8.4.x on Debian
Make sure you're using MySQL client v8.4.x.:
```
wget https://dev.mysql.com/get/mysql-apt-config_0.8.34-1_all.deb

sudo apt install ./mysql-apt-config_0.8.34-1_all.deb
```

**NOTE**: There may be a newer version of the MySQL APT Config. For more information, see [here](https://dev.mysql.com/doc/refman/8.0/en/installing.html)

Answer `OK` to the TUI prompts, and once you're back in the terminal:
```
sudo apt-get update

sudo apt-get install mysql-client
```

- verify your client version:
```
$ mysql --version
mysql  Ver 8.4.6 for Linux on x86_64 (MySQL Community Server - GPL)
```

#### `caching_sha2_password` Error
If you run into the error below when trying to connect to your Cloud SQL MySQL server using the Cloud SQL Auth Proxy, the complaint is not about the connection between the auth proxy and Cloud SQL server, but rather between your client and the auth proxy itself.  Hence why in the client connection string I added the `--get-server-public-key` flag:

- error:
```
ERROR 2061 (HY000): 2025/07/26 09:14:34 Client closed local connection on 127.0.0.1:3306
Authentication plugin 'caching_sha2_password' reported error: Authentication requires secure connection.
```

- solution:
```
$ mysql -u myuser -h 127.0.0.1 --get-server-public-key --port=3306 -p mydb01
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 283
Server version: 8.4.5-google (Google)

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```


## TODO
- how do I use [Service Connection Policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/network_connectivity_service_connection_policy) to make PSC easier?
- connection pooling
- backups/maintenance window
- how to use integration features with other GCP services (i.e. Vertex AI)
- SQL Server support (maybe)
