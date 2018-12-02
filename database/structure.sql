CREATE TABLE Pessoa(
	cpf VARCHAR(11) NOT NULL PRIMARY KEY,
	nome VARCHAR(80) NOT NULL,
	senha VARCHAR(30) NOT NULL
);

CREATE TABLE Banco(
	co_banco INT NOT NULL PRIMARY KEY,
	no_banco VARCHAR(80) NOT NULL
);

CREATE TABLE Empresa(
	co_empresa SERIAL PRIMARY KEY,
	no_empresa VARCHAR(80) NOT NULL
);

CREATE TABLE Acao(
	co_acao SERIAL NOT NULL PRIMARY KEY,
	sigla VARCHAR(10) NOT NULL UNIQUE,
	nome VARCHAR(40) NOT NULL,
	cotacao REAL NOT NULL,
	co_empresa INT NOT NULL,
	FOREIGN KEY(co_empresa) REFERENCES Empresas
);

CREATE TABLE Titulo(
	co_titulo SERIAL NOT NULL PRIMARY KEY,
	no_titulo VARCHAR(80) NOT NULL,
	tipo VARCHAR(20) NOT NULL,
	valor_minimo REAL NOT NULL,
	preco_unitario REAL NOT NULL,
	taxa REAL NOT NULL,
	taxa_variavel VARCHAR(30),
	vencimento DATE NOT NULL
);

--Dicionario: Funcionario.cpf nao pode existir em Trader.cpf e Cliente.cpf
CREATE TABLE Funcionario(
	co_funcionario SERIAL NOT NULL PRIMARY KEY,
	cpf VARCHAR(11) NOT NULL UNIQUE,
	salario REAL NOT NULL,
	turnos INT CHECK (turnos IN (1,2,3)), -- in range (1,3)
	FOREIGN KEY(cpf) REFERENCES Pessoa
);

--Dicionario: Cliente.cpf nao pode existir em Funcionario.cpf e Trader.cpf
CREATE TABLE Cliente(
	co_cliente SERIAL NOT NULL PRIMARY KEY,
	cpf VARCHAR(11) NOT NULL UNIQUE,
	perfil VARCHAR(11) NOT NULL CHECK(perfil IN ('agressivo',
												'moderado',
												'conservador')),
	FOREIGN KEY(cpf) REFERENCES Pessoa
);

--Dicionario: Trader.cpf nao pode existir em Cliente.cpf e Funcionario.cpf
CREATE TABLE Trader(
	co_trader SERIAL NOT NULL PRIMARY KEY,
	cpf VARCHAR(11) NOT NULL UNIQUE,
	performance REAL NOT NULL DEFAULT 0 CHECK(performance BETWEEN 0 AND 100),
	FOREIGN KEY(cpf) REFERENCES Pessoa
);
							  
CREATE TABLE Conta_Vinculada(
	co_conta VARCHAR(15) NOT NULL PRIMARY KEY,
	agencia INT NOT NULL,
	co_banco INT NOT NULL,
	co_cliente INT NOT NULL,
	FOREIGN KEY(co_banco) REFERENCES Banco,
	FOREIGN KEY(co_cliente) REFERENCES Cliente
);									  

CREATE TABLE Atendimento(
	co_atendimento SERIAL NOT NULL PRIMARY KEY, -- Codigo atendimento
	no_atendimento VARCHAR(100) NOT NULL, --Nome do atendimento (e.g. "Nao consigo sacar o dinheiro da minnha conta").
	co_cliente INT NOT NULL, --Codigo do cliente que abriu a chamada de atendimento
	data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Data e hora de criacao do atendimento
	resolvido BOOLEAN DEFAULT FALSE, --TRUE se resolvido
	FOREIGN KEY(co_cliente) REFERENCES Cliente
);
									  
CREATE TABLE RL_Chat(
	id_chat SERIAL NOT NULL PRIMARY KEY,
	co_atendimento INT NOT NULL,
	co_funcionario INT NOT NULL,
	data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UNIQUE(co_atendimento, co_funcionario, data_hora),
	FOREIGN KEY(co_atendimento) REFERENCES Atendimento,
	FOREIGN KEY(co_funcionario) REFERENCES Funcionario
);
									  
CREATE TABLE Historico_Mensagens(
	id_mensagem SERIAL NOT NULL PRIMARY KEY,
	id_chat INT NOT NULL,
	origem VARCHAR(11) NOT NULL CHECK(origem IN('funcionario','cliente')),
	data_hota TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	mensagem VARCHAR(2000) NOT NULL,
	FOREIGN KEY(id_chat) REFERENCES RL_Chat
);

CREATE TABLE Ordem_Acao(
	co_ordem SERIAL NOT NULL PRIMARY KEY,
	co_cliente INT NOT NULL,
	co_acao INT NOT NULL,
	vencimento DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	tipo VARCHAR(11) NOT NULL CHECK(tipo IN('swing trade', 'day trade')),
	quantidade REAL NOT NULL CHECK(quantidade >= 0),
	preco_unitario REAL NOT NULL CHECK(preco_unitario >= 0),
	data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	executada BOOLEAN NOT NULL DEFAULT FALSE,
	FOREIGN KEY(co_cliente) REFERENCES Cliente,
	FOREIGN KEY(co_acao) REFERENCES Acao
);

CREATE TABLE Ordem_Titulo(
	co_ordem SERIAL NOT NULL PRIMARY KEY,
	co_cliente INT NOT NULL,
	co_titulo INT NOT NULL,
	taxa_fixa REAL NOT NULL CHECK(taxa_fixa >= 0),
	quantidade REAL NOT NULL CHECK(quantidade >= 0),
	preco_unitario REAL NOT NULL CHECK(preco_unitario >= 0),
	data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	executada BOOLEAN NOT NULL DEFAULT FALSE,
	FOREIGN KEY(co_cliente) REFERENCES Cliente,
	FOREIGN KEY(co_titulo) REFERENCES Titulo
);
									
CREATE TABLE Transacao(
	co_transacao SERIAL NOT NULL PRIMARY KEY,
	quantidade REAL NOT NULL CHECK(quantidade >= 0),
	preco REAL NOT NULL CHECK(quantidade >= 0),
	data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	co_ordem_acao INT NOT NULL,
	FOREIGN KEY(co_ordem_acao) REFERENCES Ordem_Acao
);

CREATE TABLE Bonus(
	co_bonus SERIAL NOT NULL PRIMARY KEY,
	valor REAL NOT NULL CHECK(valor >= 0),
	ano INT NOT NULL CHECK(ano >= 2018),
	mes INT NOT NULL CHECK(mes >= 1 AND mes <= 12),
	condicao VARCHAR(500) NOT NULL 
);

CREATE TABLE RL_TraderBonus(
	co_bonus INT NOT NULL,
	co_trader INT NOT NULL,
	PRIMARY KEY(co_bonus, co_trader),
	FOREIGN KEY(co_bonus) REFERENCES Bonus,
	FOREIGN KEY(co_trader) REFERENCES Trader
);
									
CREATE TABLE RL_TraderCliente(
	co_trader INT NOT NULL,
	co_cliente INT NOT NULL,
	PRIMARY KEY(co_trader, co_cliente),
	FOREIGN KEY(co_trader) REFERENCES Trader,
	FOREIGN KEY(co_cliente) REFERENCES Cliente
);
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									
									

