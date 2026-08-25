# Portfólio — Linguagens de Descrição de Hardware (LDH)

Atividades desenvolvidas na disciplina de Linguagens de Descrição de Hardware, do curso de Engenharia de Controle e Automação do **IFSC — Câmpus Chapecó**, no semestre **2026/2**.

Cada pasta corresponde a uma aula e contém o projeto completo do Quartus, pronto para abrir e compilar.

---

## Ambiente

| Item | Versão / Modelo |
|---|---|
| Software | Quartus Prime Lite Edition 18.1 |
| Placa | Terasic DE10-Lite |
| FPGA | Intel MAX 10 — `10M50DAF484C6GES` |
| Linguagem | Verilog HDL e esquemático (BDF) |

---

## Sobre os arquivos versionados

Somente os arquivos-fonte são mantidos no repositório: descrições de hardware (`.v`, `.bdf`, `.bsf`) e configurações de projeto (`.qpf`, `.qsf`).

Os diretórios gerados automaticamente pelo Quartus a cada compilação — `db/`, `incremental_db/`, `output_files/`, `simulation/` e `timing/` — são ignorados pelo `.gitignore`. Eles somam centenas de megabytes, mudam a cada build e são reconstruídos a partir dos fontes, portanto não pertencem ao controle de versão.
