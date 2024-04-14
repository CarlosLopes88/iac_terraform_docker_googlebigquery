provider "google" {
  project     = "modelagem-dw-iac"
  region      = "us-west1"
}

resource "google_bigquery_dataset" "sales_dataset" {
  dataset_id                  = "sales_dw_dataset"
  friendly_name               = "Sales DW Dataset IaC"
  description                 = "Sales DW Dataset IaC with terraform and Google BigQuery"
  location                    = "US"
}

resource "google_bigquery_table" "table_1" {
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.sales_dataset.dataset_id
  table_id            = "tb_customers"

  schema = jsonencode([
    {
      "name": "customer_id",
      "type": "INTEGER",
      "mode": "REQUIRED"
    },
    {
      "name": "customer_name",
      "type": "STRING",
      "mode": "REQUIRED"
    },
    {
      "name": "customer_type",
      "type": "STRING",
      "mode": "REQUIRED"
    }
  ])
}

resource "google_bigquery_table" "table_2" {
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.sales_dataset.dataset_id
  table_id            = "tb_product"

  schema = jsonencode([
    {
      "name": "product_id",
      "type": "INTEGER",
      "mode": "REQUIRED"
    },
    {
      "name": "product_name",
      "type": "STRING",
      "mode": "REQUIRED"
    },
    {
      "name": "product_category",
      "type": "STRING",
      "mode": "REQUIRED"
    }
  ])
}

resource "google_bigquery_table" "table_3" {
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.sales_dataset.dataset_id
  table_id            = "tb_sale"

  schema = jsonencode([
    {
      "name": "sale_id",
      "type": "INTEGER",
      "mode": "REQUIRED"
    },
    {
      "name": "customer_id",
      "type": "INTEGER",
      "mode": "REQUIRED"
    },
    {
      "name": "product_id",
      "type": "INTEGER",
      "mode": "REQUIRED"
    },
    {
      "name": "amount_sale",
      "type": "FLOAT",
      "mode": "REQUIRED"
    },
    {
      "name": "date",
      "type": "TIMESTAMP",
      "mode": "REQUIRED"
    }
  ])
}

resource "random_string" "random_id" {
  length  = 8
  special = false
  upper   = false
}

resource "google_bigquery_job" "job_sql_1" {
  job_id = "sales_job_${random_string.random_id.result}_1"

  labels = {
    "sales_job" = "job_sql_1"
  }

  load {
    source_uris = [
      "gs://sales-modeling-dw/tb_customers.csv",
    ]

    destination_table {
      project_id = google_bigquery_table.table_1.project
      dataset_id = google_bigquery_table.table_1.dataset_id
      table_id   = google_bigquery_table.table_1.table_id
    }

    skip_leading_rows = 1
    schema_update_options = ["ALLOW_FIELD_RELAXATION", "ALLOW_FIELD_ADDITION"]
    write_disposition = "WRITE_APPEND"
    autodetect = true
  }
}

resource "google_bigquery_job" "job_sql_2" {
  job_id = "sales_job_${random_string.random_id.result}_2"

  labels = {
    "sales_job" = "job_sql_2"
  }

  load {
    source_uris = [
      "gs://sales-modeling-dw/tb_product.csv",
    ]

    destination_table {
      project_id = google_bigquery_table.table_2.project
      dataset_id = google_bigquery_table.table_2.dataset_id
      table_id   = google_bigquery_table.table_2.table_id
    }

    skip_leading_rows = 1
    schema_update_options = ["ALLOW_FIELD_RELAXATION", "ALLOW_FIELD_ADDITION"]
    write_disposition = "WRITE_APPEND"
    autodetect = true
  }
}

resource "google_bigquery_job" "job_sql_3" {
  job_id = "sales_job_${random_string.random_id.result}_3"

  labels = {
    "sales_job" = "job_sql_3"
  }

  load {
    source_uris = [
      "gs://sales-modeling-dw/tb_sale.csv",
    ]

    destination_table {
      project_id = google_bigquery_table.table_3.project
      dataset_id = google_bigquery_table.table_3.dataset_id
      table_id   = google_bigquery_table.table_3.table_id
    }

    skip_leading_rows = 1
    schema_update_options = ["ALLOW_FIELD_RELAXATION", "ALLOW_FIELD_ADDITION"]
    write_disposition = "WRITE_APPEND"
    autodetect = true
  }
}