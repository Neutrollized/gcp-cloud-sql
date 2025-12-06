# Examples & Setups

- [Building AI-powered apps on GCP databases using pgvector, LLMs and LangChain](https://cloud.google.com/blog/products/databases/using-pgvector-llms-and-langchain-with-google-cloud-databases)

## pgvector
```sql
CREATE EXTENSION IF NOT EXISTS vector;
```

## Google ML Integration
`google_ml_integration` provides interface to BQML and Vertex AI services

```sql
CREATE EXTENSION IF NOT EXISTS google_ml_integration CASCADE;
```
 `CASCADE` means automatically install any other extension that is an dependency for `google_ml_integration`
