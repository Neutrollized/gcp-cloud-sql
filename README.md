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


## MySQL connection troubleshooting
If you run into the error below when trying to connect to your Cloud SQL MySQL server using the Cloud SQL Auth Proxy, the complaint is not about the connection between the auth proxy and Cloud SQL server, but rather between your client and the auth proxy itself.  Hence why in the client connection string I added the `--get-server-public-key` flag:

- sample error:
```
ERROR 2061 (HY000): 2025/07/26 09:14:34 Client closed local connection on 127.0.0.1:3306
Authentication plugin 'caching_sha2_password' reported error: Authentication requires secure connection.
```


## TODO
- custom VPC
- Private Service Connect (PSC)
- connection pooling
- backups/maintenance window
- how to use integration features with other GCP services (i.e. Vertex AI)
- SQL Server support (maybe)
