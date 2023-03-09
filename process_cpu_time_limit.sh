#!/bin/bash

# Define os valores padrão para o tempo e o limite de CPU
MAX_RUNTIME=600  # 10 minutos em segundos
CPU_LIMIT=50  # 50% de uso de CPU

# Define as opções do script
while getopts "l:r:c:t:p:" opt; do
  case ${opt} in
    l ) LOGFILE="false";;
    r ) RESTART="true";;
    c ) CPU_LIMIT="$OPTARG";;
    t ) MAX_RUNTIME="$OPTARG";;
    p ) PROCESS_NAME="$OPTARG";;
  esac
done

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Usage: $0 [-r] [-l logfile] [-c cpu_limit] [-t max_runtime] -p process_name"
  echo ""
  echo "Options:"
  echo "  -r restarts the process automatically if the limits are exceeded"
  echo "  -l specifies type show msg. if informed hide common phase."
  echo "  -c <cpu_limit> defines the CPU usage limit in percentage (default is 50%)"
  echo "  -t <max_runtime> defines the maximum runtime in seconds (default is 600 seconds)"
  echo "  -p <process_name> specifies the name of the process to be monitored"
  exit 0
fi


# Obtém o PID do processo
PID=$(pgrep $PROCESS_NAME)

# Verifica se o processo está em execução
if [ -z "$PID" ]; then
  echo "Processo $PROCESS_NAME não encontrado."
  exit 1
fi

# Obtém o tempo de execução atual do processo em segundos
RUNTIME=$(ps -o etimes= -p $PID)

# Obtém o uso atual de CPU do processo em porcentagem
CPU_USAGE=$(ps -o %cpu= -p $PID)

# Verifica se o tempo de execução excedeu o tempo máximo
if [ $RUNTIME -gt $MAX_RUNTIME ]; then
  echo "Processo $PROCESS_NAME executando há mais de $MAX_RUNTIME segundos. Reiniciando o processo..."
  if [ "$RESTART" = "true" ]; then
    kill $PID
    # Adicione aqui o comando para iniciar o processo novamente
    # Restart the process
    if [ "$RESTART" = true ]; then
        echo "Restarting the process..."
        systemctl stop "$PROCESS_NAME"
        systemctl start "$PROCESS_NAME"
    fi

  fi

    echo "$(date): Processo $PROCESS_NAME reiniciado após tempo de execução excedido."

else
  # Verifica se o uso de CPU excedeu o limite definido
  if (( $(echo "$CPU_USAGE > $CPU_LIMIT" | bc -l) )); then
    echo "Processo $PROCESS_NAME usando mais de $CPU_LIMIT% de CPU. Reiniciando o processo..."
    if [ "$RESTART" = "true" ]; then
        kill $PID
        # Adicione aqui o comando para iniciar o processo novamente
        # Restart the process
        if [ "$RESTART" = true ]; then
            echo "Restarting the process..."
            systemctl stop "$PROCESS_NAME"
            systemctl start "$PROCESS_NAME"
        fi
    fi
      echo "$(date): Processo $PROCESS_NAME reiniciado após uso de CPU excedido."
  else
    if [ "$LOGFILE" = "false" ]; then
    echo "Processo $PROCESS_NAME executando normalmente."
    fi
  fi
fi