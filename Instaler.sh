#!/bin/bash

# Cores para o terminal
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}===========================================${NC}"
echo -e "${GREEN}    Instalador de Ferramentas Bug Bounty   ${NC}"
echo -e "${CYAN}===========================================${NC}"

# 1. Atualização e Dependências
echo -e "${YELLOW}[*] Atualizando sistema e instalando dependências...${NC}"
sudo apt update && sudo apt install -y git curl wget golang

# 2. Configuração do ambiente Go (Importante para rodar de qualquer lugar)
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Adiciona ao .bashrc se ainda não estiver lá para ser permanente
if ! grep -q "GOPATH" ~/.bashrc; then
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
fi

# 3. Instalação das Ferramentas via Go
echo -e "${GREEN}[+] Instalando Subfinder...${NC}"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

echo -e "${GREEN}[+] Instalando Assetfinder...${NC}"
go install -v github.com/tomnomnom/assetfinder@latest

echo -e "${GREEN}[+] Instalando Katana...${NC}"
go install -v github.com/projectdiscovery/katana/cmd/katana@latest

echo -e "${GREEN}[+] Instalando Httpx...${NC}"
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

echo -e "${GREEN}[+] Instalando Nuclei...${NC}"
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

echo -e "${GREEN}[+] Instalando GF...${NC}"
go install -v github.com/tomnomnom/gf@latest

# 4. Configuração extra do GF (Patterns)
echo -e "${YELLOW}[*] Configurando padrões do GF...${NC}"
mkdir -p ~/.gf
git clone https://github.com/1ndianl33t/Gf-Patterns /tmp/gf-patterns
cp /tmp/gf-patterns/*.json ~/.gf/
rm -rf /tmp/gf-patterns

# 5. Inicialização do Nuclei (Baixar templates)
echo -e "${YELLOW}[*] Baixando templates do Nuclei...${NC}"
$GOPATH/bin/nuclei -ut

echo -e "${CYAN}===========================================${NC}"
echo -e "${GREEN}        INSTALAÇÃO CONCLUÍDA!             ${NC}"
echo -e "${CYAN}===========================================${NC}"
echo -e "${YELLOW}DICA: Digite 'source ~/.bashrc' para ativar agora.${NC}"
