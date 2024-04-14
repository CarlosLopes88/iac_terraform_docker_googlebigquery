# Projeto Data Warehouse com Google Cloud Platform e Terraform

Este projeto tem como objetivo criar um ambiente de Data Warehouse (DW) na Google Cloud Platform (GCP) utilizando o Terraform e um container Docker como máquina cliente. O DW será construído no Google BigQuery, e os dados serão ingetados a partir de arquivos CSV armazenados em um bucket do Google Cloud Storage.

## Estrutura de Pastas

A estrutura de pastas do projeto é a seguinte:

iac_terraform_docker_googlebigquery/  
│  
├── data/  
│   ├── tb_customers.csv  
│   ├── tb_product.csv  
│   └── tb_sales.csv  
│  
├── iac_bigquery/  
│   └── main.tf  
│  
├── ingestion.py  
├── Dockerfile  
├── suachavegoogle.json  
├── README.md  
├── requirements.txt  
├── .gitignore  
└── .env  

## Pré-requisitos para Execução

Para executar este projeto, você precisará de:

- Docker instalado em sua máquina local.
- Credenciais do Google Cloud Platform (GCP) em formato JSON.
- Um projeto criado na GCP.
- Arquivos CSV contendo os dados a serem carregados no BigQuery.

Para ativar um ambiente virtual

        python -m venv .venv (windows)
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
        .\.venv\Scripts\activate


obs: o arquivo requirements instala o dotenv e o  google-cloud-storage em seu ambiente .venv que pode ser feito ...

        pip install python-dotenv
        pip install google-cloud-storage requests

ou:  

        pip instal requirements


## Passo a Passo de Implementação

### 1. Criar um Bucket e Enviar Arquivos para o Google Cloud Storage

Antes de iniciar o container Docker, execute o arquivo Python `ingestion.py` para criar um bucket no Google Cloud Storage e enviar os arquivos CSV para ele. Certifique-se de ter configurado corretamente o arquivo `.env` com as credenciais do GCP e os URLs dos arquivos CSV no GitHub.

        python ingestion.py

### 2. Criar uma Imagem Docker e Executar um Container

Após criar e enviar os arquivos para o bucket. abra o terminal ou prompt de comando e navegue até a pasta iac_terraform_docker_googlebigquery. Em seguida, execute os seguintes comandos para criar a imagem Docker:

        docker build -t image-modelagem-iac:iac_project .

Depois de criar a imagem Docker, execute o seguinte comando para criar e executar um container Docker:

        docker run -dit --name my-dw-iac -v "diretório local a ser mapeado":/iac_bigquery image-modelagem-iac:iac_project /bin/bash

### 3. Executar o Terraform na Máquina Cliente

Dentro do container Docker, antes de executar o Terraform, configure suas credenciais do GCP e defina o projeto padrão. Execute o seguinte comando:

        gcloud auth application-default set-quota-project SEU_PROJETO

Agora navegue até a pasta `iac_bigquery` e execute os seguintes comandos para inicializar e aplicar o Terraform:

        bash
        cd /iac_bigquery
        terraform init
        terraform apply

## Tecnologias Utilizadas

- Docker: Para criar e executar um container como máquina cliente.
- Terraform: Para provisionar recursos na Google Cloud Platform.
- Google Cloud Platform (GCP): Utilizada para hospedar o Data Warehouse no BigQuery.
- Google BigQuery: Serviço de armazenamento de dados e análise de data warehouse totalmente gerenciado e escalonável.
