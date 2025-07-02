# Etapa 1: Usar uma imagem base oficial do Python com Alpine.
# A versão 3.10-alpine é leve e consistente com o README do projeto.
FROM python:3.13.4-alpine3.22


# Definir o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copiar o arquivo de dependências primeiro para aproveitar o cache de camadas do Docker
COPY requirements.txt .

# Instalar dependências do sistema, instalar pacotes Python e remover as dependências
# de build em uma única camada para otimizar o tamanho da imagem.
# gcc e musl-dev são necessários para compilar algumas bibliotecas Python no Alpine.
RUN pip install --no-cache-dir -r requirements.txt 

# Copiar o restante do código da aplicação.
# O arquivo .dockerignore será usado para excluir arquivos desnecessários.
COPY . .

EXPOSE 8000

# Comando para iniciar a aplicação quando o contêiner for executado.
# --host 0.0.0.0 é necessário para que a aplicação seja acessível de fora do contêiner.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]