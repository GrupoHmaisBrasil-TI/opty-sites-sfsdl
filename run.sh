#!/bin/sh
# Garante que o script pare se houver um erro
set -e

# Carrega as variáveis de ambiente do arquivo .env
# O `set -a` faz com que todas as variáveis definidas a partir daqui sejam exportadas
# O `.` (ou `source`) executa o conteúdo do arquivo no shell atual
if [ -f /app/.env ]; then
  set -a
  . /app/.env
  set +a
else
  echo "AVISO: Arquivo /app/.env não encontrado. A aplicação pode falhar."
fi

# Garante que estamos executando a partir do diretório correto
cd /app/src

# Loop para executar o script 6 vezes em um minuto (6 * 10s = 60s)
for i in 1 2 3 4 5 6
do
   echo "Executando o script pela vez $i..."
   /usr/local/bin/python3 main.py
   sleep 10
done
