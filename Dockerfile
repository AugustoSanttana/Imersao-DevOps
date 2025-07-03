# Define a imagem base. Usamos uma imagem Alpine por ser leve.
# É uma boa prática fixar a versão para garantir builds consistentes.
FROM python:3.13.5-alpine3.22

# Define o diretório de trabalho dentro do contêiner.
# Todos os comandos subsequentes serão executados a partir deste diretório.
WORKDIR /app

# Copia o arquivo de dependências para o diretório de trabalho.
# Fazemos isso em um passo separado para aproveitar o cache do Docker.
# A camada de instalação de dependências só será reconstruída se o requirements.txt mudar.
COPY requirements.txt .

# Instala as dependências do projeto.
# --no-cache-dir: Desabilita o cache do pip para reduzir o tamanho da imagem.
# -r requirements.txt: Instala os pacotes listados no arquivo.
RUN pip install --no-cache-dir -r requirements.txt

# Copia todos os arquivos do projeto do host para o diretório de trabalho no contêiner.
COPY . .

# Expõe a porta 8000 para que a aplicação possa ser acessada de fora do contêiner.
# O Uvicorn, por padrão, roda na porta 8000.
EXPOSE 8000

# Comando para executar a aplicação quando o contêiner for iniciado.
# Usamos "0.0.0.0" como host para que a aplicação seja acessível externamente.
# O comando `uvicorn app:app --reload` do README é para desenvolvimento; aqui usamos o comando para produção.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]