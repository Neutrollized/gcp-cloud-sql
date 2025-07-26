# GCP Cloud SQL

- [Cloud SQL documentation](https://cloud.google.com/sql/docs/introduction)

Deploying GCP Cloud SQL with Terraform.  Learn about the different configuration and connectivity options.

Currently only for MySQL and PostgreSQL (I don't know enough about SQL Server to make usage or configuration recommendations -- sorry, Microsoft)

[Cloud SQL DB Instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance)

[Cloud SQL Database](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database)

[Cloud SQL User](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user)

[Secret Manager Secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret)

[Secret Manager Secret Version](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version)

[Ephemeral Random Password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/ephemeral-resources/password)


## MySQL connection troubleshooting
If you run into the error below when trying to connect to your Cloud SQL MySQL server using the Cloud SQL Auth Proxy, the complaint is not about the connection between the auth proxy and Cloud SQL server, but rather between your client and the auth proxy itself.  Hence why in the client connection string I added the `--get-server-public-key` flag:

- sample error:
```
ERROR 2061 (HY000): 2025/07/26 09:14:34 Client closed local connection on 127.0.0.1:3306
Authentication plugin 'caching_sha2_password' reported error: Authentication requires secure connection.
```


## TODO
- custom VPC
- Private services access
- Private Service Connect (PSC)
- connection pooling
- backups/maintenance window
- how to use integrations with other GCP services (i.e. Vertex AI)
