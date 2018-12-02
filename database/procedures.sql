-- Quando uma movimentacão é criada, atualizar o saldo do cliente.
CREATE OR REPLACE FUNCTION AtualizaSaldo()
RETURNS TRIGGER AS $$
BEGIN
	IF(NEW.tipo = 'deposito') THEN
		UPDATE Cliente SET saldo = saldo + NEW.quantidade WHERE co_cliente IN (SELECT co_cliente FROM Conta_Vinculada WHERE co_conta = NEW.co_conta);
		RETURN NEW;
	END IF;

	IF(NEW.tipo = 'saque') THEN
		UPDATE Cliente SET saldo = saldo - NEW.quantidade WHERE co_cliente IN (SELECT co_cliente FROM Conta_Vinculada WHERE co_conta = NEW.co_conta);
		RETURN NEW;
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER InsereMovimentacao AFTER INSERT ON Movimentacao
FOR EACH ROW EXECUTE PROCEDURE AtualizaSaldo();

-- Quando uma ordem é criada, atualizar o saldo do cliente.
CREATE OR REPLACE FUNCTION RemoveSaldoCliente()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE Cliente SET saldo = saldo - NEW.quantidade*NEW.preco_unitario WHERE co_cliente = NEW.co_cliente;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER InsereOrdemAcao AFTER INSERT ON Ordem_Acao
FOR EACH ROW EXECUTE PROCEDURE RemoveSaldoCliente();

CREATE TRIGGER InsereOrdemTitulo AFTER INSERT ON Ordem_Titulo
FOR EACH ROW EXECUTE PROCEDURE RemoveSaldoCliente();