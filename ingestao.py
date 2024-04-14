import os
from dotenv import load_dotenv
from google.cloud import storage
import requests

# Carregar as variáveis de ambiente do arquivo .env
load_dotenv()

# Defina suas credenciais do Google Cloud
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")

# Crie um cliente do Google Cloud Storage
client = storage.Client()

def criar_bucket(nome_bucket):
    """Cria um bucket no Google Cloud Storage"""
    bucket = client.create_bucket(nome_bucket)
    print(f"Bucket '{bucket.name}' criado com sucesso.")
    return bucket

def enviar_arquivo_para_bucket(bucket, url, nome_objeto):
    """Envia um arquivo de uma URL para um bucket do Google Cloud Storage"""
    blob = bucket.blob(nome_objeto)
    conteudo = requests.get(url).content
    blob.upload_from_string(conteudo)
    print(f"Arquivo '{nome_objeto}' enviado para o bucket.")

# Defina as informações do bucket e dos arquivos a partir do arquivo .env
nome_bucket = os.getenv("NOME_BUCKET")
url_arquivo1 = os.getenv("URL_ARQUIVO_1")
url_arquivo2 = os.getenv("URL_ARQUIVO_2")
url_arquivo3 = os.getenv("URL_ARQUIVO_3")

# Crie o bucket no Google Cloud Storage
bucket = criar_bucket(nome_bucket)

# Envie os arquivos diretamente do GitHub para o bucket
enviar_arquivo_para_bucket(bucket, url_arquivo1, "tb_customer.csv")
enviar_arquivo_para_bucket(bucket, url_arquivo2, "tb_product.csv")
enviar_arquivo_para_bucket(bucket, url_arquivo3, "tb_sales.csv")
