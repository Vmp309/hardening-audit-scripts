#!/bin/bash

# Arquivo de saída
RELATORIO=~/Documentos/Auditoria_Hardening/relatorio_seguranca.txt
echo "Relatório de Auditoria de Sistema – $(date)" > "$RELATORIO"
echo "==========================================" >> "$RELATORIO"

# Atualização de repositórios
echo "[+] Atualizando repositórios..." | tee -a "$RELATORIO"
sudo apt update >> "$RELATORIO" 2>&1

# Pacotes desatualizados
echo -e "\n[+] Pacotes com atualizações disponíveis:" | tee -a "$RELATORIO"
apt list --upgradable 2>/dev/null | tee -a "$RELATORIO"

# Verificar origem dos pacotes
echo -e "\n[+] Pacotes com origem desconhecida ou suspeita:" | tee -a "$RELATORIO"
dpkg-query -W -f='${binary:Package} ${Version} ${Origin}\n' | grep -v "Ubuntu" | tee -a "$RELATORIO"

# Verificar pacotes instalados fora de repositórios (debsnap)
echo -e "\n[+] Pacotes não pertencentes a repositórios oficiais (debsnap):" | tee -a "$RELATORIO"
command -v debsnap >/dev/null || sudo apt install -y debsnap >> "$RELATORIO"
sudo debsnap --list | tee -a "$RELATORIO"

# Verificar integridade dos pacotes
echo -e "\n[+] Verificando integridade dos pacotes (debsums):" | tee -a "$RELATORIO"
command -v debsums >/dev/null || sudo apt install -y debsums >> "$RELATORIO"
sudo debsums -s | tee -a "$RELATORIO"

# Verificar rootkits (rkhunter)
echo -e "\n[+] Escaneando por rootkits (rkhunter):" | tee -a "$RELATORIO"
command -v rkhunter >/dev/null || sudo apt install -y rkhunter >> "$RELATORIO"
sudo rkhunter --update >> "$RELATORIO"
sudo rkhunter --check --sk >> "$RELATORIO"

# Finalização
echo -e "\nRelatório final salvo em: $RELATORIO"

