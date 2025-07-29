# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## [0.2.1] - 2025-07-29
### Added
- Variable `ipv4_enabled` (default: `true`)
- Variable `enable_private_path_for_gcp_services` (default: `false`)
- Output public IP of Cloud SQL instance if one exists
### Changed
- Switched from `cloud_sql_proxy` (v1) to a simpler `cloud-sql-proxy` (v2) command for connecting to the Cloud SQL instance

## [0.2.0] - 2025-07-28
### Added
- Private networks (Private Services Access) for *default* VPC network
- Dynamic block for `database_flags`
- Dynamic block for `authorized_networks`
- Variable, `ssl_mode` (default: `ENCYRYPTED_ONLY`)
- `examples/python_client.py` for testing connectivity to public IP
- `terraform.tfvars.sample`
### Changed
- Default `machine_type` from `g1-small` to `f1-micro`

## [0.1.0] - 2025-07-26
### Added
- Initial commit
