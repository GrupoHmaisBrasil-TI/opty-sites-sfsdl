# Imagem base com Python
FROM python:3.11-slim

# Instala o cron e limpa o cache do apt para manter a imagem pequena
RUN apt-get update && apt-get install -y cron && apt-get clean && rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho principal
WORKDIR /app

# Cria o diretório onde os arquivos de saída serão salvos
RUN mkdir -p /app/file

# Copia os arquivos de dependência e instala
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia os códigos da aplicação
COPY src/ ./src
COPY sql/ ./sql

COPY .env .
# Copia e prepara o agendador (cron)
COPY run.sh /app/run.sh
COPY crontab /etc/cron.d/scheduler

# Dá as permissões corretas para os arquivos do cron
RUN chmod 0744 /app/run.sh
RUN chmod 0644 /etc/cron.d/scheduler

# Aplica o crontab
RUN crontab /etc/cron.d/scheduler

# (Opcional, mas recomendado) Garante que a crontab termine com uma nova linha
RUN echo "" >> /etc/cron.d/scheduler

# Comando para iniciar o serviço do cron em modo "foreground"
# Isso mantém o contêiner em execução
CMD ["cron", "-f"]
