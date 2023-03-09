## Monitor de Processos em Shell Script
Este script shell é uma ferramenta simples que monitora o tempo de execução e o uso de CPU de um processo em um sistema Linux. Se os limites definidos forem excedidos, o script reinicia o processo automaticamente. Isso é útil para garantir que um processo importante esteja sempre em execução e não consuma muitos recursos do sistema.

### Instalação
1. Clone este repositório em sua máquina local:
   git clone https://github.com/elielcio/process_cpu_time_limit.git /usr/local/scripts/process_cpu_time_limit/

2.Acesse o diretório do repositório:
    cd process_cpu_time_limit

3.Dê permissão de execução para o script:
   sudo chmod +x /usr/local/scripts/process_cpu_time_limit/process_cpu_time_limit.sh

### Utilização
O script é executado a partir da linha de comando e aceita as seguintes opções:

-l especifica tipo de saida de informações. Caso seja informado não exibirá as mensagens basicas. Use para comando crom que geram logs.
-r : reinicia o processo automaticamente se os limites forem excedidos.
-c <cpu_limit> : define o limite de uso de CPU em porcentagem (padrão é 50%).
-t <max_runtime> : define o tempo máximo de execução em segundos (padrão é 600 segundos).
-p <process_name> : especifica o nome do processo a ser monitorado.

Por exemplo, para monitorar um processo chamado "meu_processo" com um limite de uso de CPU de 70% e um tempo máximo de execução de 900 segundos e reiniciar automaticamente se os limites forem excedidos, execute o seguinte comando:

. /usr/local/scripts/process_cpu_time_limit/process_cpu_time_limit.sh -r -c 70 -t 900 -p meu_processo

O script também pode ser executado periodicamente usando uma ferramenta de agendamento, como o cron. Por exemplo, para executar o script a cada 5 minutos, adicione a seguinte linha ao arquivo crontab:

*/5 * * * * /usr/local/scripts/process_cpu_time_limit/process_cpu_time_limit.sh -l -r -c 50 -t 600 -p meu_processo >> /var/log/process_cpu_time_limit_seuprocesso.log 2>&1

Este comando executará o script a cada 5 minutos, monitorando o processo "meu_processo" com um limite de uso de CPU de 50% e um tempo máximo de execução de 600 segundos. Ele também enviará a saída para o arquivo /var/log/process_cpu_time_limit_seuprocesso.log para registro.

### Conclusão
Este script shell é uma ferramenta simples e útil para monitorar e reiniciar automaticamente um processo em um sistema Linux. Ele pode ser facilmente personalizado e integrado a um sistema de agendamento para automatizar o monitoramento de processos críticos.