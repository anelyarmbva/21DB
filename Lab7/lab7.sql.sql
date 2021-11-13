---- LABARATORY WORK 7 Rymbayeva Anelya
-- 1 Task:

--1)How can we store large-object types?
--blob: binary large object -- object is a large collection of uninterpreted binary data
--clob: character large object -- object is a large collection of character data
--2)What is the difference between privilege, role and user?
--role stores many privileges and users may be granted by roles
--privilege is a unary permissions that can be given to users
--users can be described as multiple account which can be granted by roles and privileges so that they can do some operations with data from database


--2 Task:
CREATE ROLE accountant;
CREATE ROLE administrator;
CREATE ROLE support;


GRANT SELECT,INSERT ON transactions,accounts TO accountant;
GRANT ALL ON transactions,customers,accounts TO administrator;
GRANT SELECT,UPDATE,DELETE ON accounts,customers TO support;

CREATE USER Anelya;
CREATE USER Deyna;
CREATE USER Adema;

GRANT administrator TO anelya;
GRANT accountant TO deyna;
GRANT support TO adema;

CREATE USER test_user;
GRANT ALL PRIVILEGES ON transactions,customers,accounts TO test_user WITH GRANT OPTION;
REVOKE ALL ON transactions,accounts,customers FROM test_user;


--5 Task:
CREATE UNIQUE INDEX customer_unique_acc ON accounts(account_id,currency);
CREATE INDEX transaction_cur_bal ON accounts(currency,balance);


--6 Task:
DO $$
    DECLARE
        f_balance INT;
        acc_limit INT;
        trans_amount INT;
        src_acc VARCHAR;
        dst_acc VARCHAR;
        trans_id INT;
    BEGIN
        INSERT INTO transactions VALUES(15,now(),'RS88012','NT10204',5000,'init');
        SELECT transactions.id,transactions.amount,src_account,dst_account INTO trans_id,trans_amount,src_acc,dst_acc
            FROM transactions WHERE id = 15;
        UPDATE accounts SET balance=balance-trans_amount
        WHERE account_id=src_acc;
        UPDATE accounts SET balance=balance+trans_amount
        WHERE account_id=dst_acc;
        SELECT accounts.balance,accounts.limit INTO f_balance,acc_limit
            FROM accounts WHERE account_id=src_acc;
        IF acc_limit>=f_balance THEN
            UPDATE accounts SET balance=balance+trans_amount
            WHERE account_id=src_acc;
            UPDATE accounts SET balance=balance-trans_amount
            WHERE account_id=dst_acc;
            UPDATE transactions SET status = 'rollback' WHERE id=trans_id;
        ELSE
            UPDATE transactions SET status = 'commit' WHERE id=trans_id;
        END IF;
        COMMIT;
END$$;