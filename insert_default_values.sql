set serveroutput on

begin
    insert into motoristas (nome, cpf)
    values('Matheus Santos', '11122233344');

    insert into motoristas (nome, cpf)
    values('João da Silva', '22233344455');

    insert into motoristas (nome, cpf)
    values('Andreia Pereira', '33344455566');
exception
    when others then
        dbms_output.put_line('Erro ao inserir motoristas: ' || SQLERRM);
        null;
end;
/

begin
    insert into cnhs (id_motorista, nr_cnh, pontos, tp_cnh)
    values(1, '123456789', 12, 'normal');

    insert into cnhs (id_motorista, nr_cnh, pontos, tp_cnh)
    values(2, '987654321', 0, 'normal');

    insert into cnhs (id_motorista, nr_cnh, pontos, tp_cnh)
    values(3, '543219876', 20, 'trabalho');
exception
    when others then
        dbms_output.put_line('Erro ao inserir cnhs: ' || SQLERRM);
        null;
end;
/

begin
    insert into veiculos (id_motorista, placa)
    values(1, 'asd-f129');

    insert into veiculos (id_motorista, placa)
    values(2, 'asf-1d19');

    insert into veiculos (id_motorista, placa)
    values(3, 'fsd-9c19');
exception
    when others then
        dbms_output.put_line('Erro ao inserir veiculos: ' || SQLERRM);
        null;
end;
/

begin
    insert into ruas (cep, nome)
    values('19918444', 'rua pedro bandeira');

    insert into ruas (cep, nome)
    values('19918555', 'rua augusto nunes');

    insert into ruas (cep, nome)
    values('19918999', 'rua vila caipira');
exception
    when others then
        dbms_output.put_line('Erro ao inserir ruas: ' || SQLERRM);
        null;
end;
/

begin
    insert into acidentes(id_motorista, id_veiculo, id_causador, id_veiculo_causador, id_rua, descricao, dt_acidente)
    values(1, 1, 1, 1, 1, 'o motorista estava acima da velocidade permitida e bateu em um carro', sysdate);

    insert into acidentes(id_motorista, id_veiculo, id_rua, descricao, dt_acidente)
    values(2, 2, 1, 'o motorista teve seu carro batido devido à outro motorista em alta velocidade', sysdate);

    insert into acidentes(id_motorista, id_veiculo, id_causador, id_veiculo_causador, id_rua, descricao, dt_acidente)
    values(3, 3, null, null, 2, 'um motorista estava acima da velocidade permitida e bateu em um carro', sysdate);
exception
    when others then
        dbms_output.put_line('Erro ao inserir acidentes: ' || SQLERRM);
        null;
end;
/

begin
    insert into multas(id_motorista, id_veiculo, descricao, valor, dt_inicio, dt_vencimento, dt_pagamento)
    values(1, 1, 'o motorista estava acima da velocidade permitida e bateu em um carro', 300, sysdate, (sysdate + 30), null);

    insert into multas(id_motorista, id_veiculo, descricao, valor, dt_inicio, dt_vencimento, dt_pagamento)
    values(2, 2, 'o motorista estava acima da velocidade permitida', 150, (sysdate - 15), (sysdate + 45), (sysdate - 10));

    insert into multas(id_motorista, id_veiculo, descricao, valor, dt_inicio, dt_vencimento, dt_pagamento)
    values(3, 3, 'o motorista estava acima da velocidade permitida', 150, (sysdate - 30), sysdate, null);
exception
    when others then
        dbms_output.put_line('Erro ao inserir multas: ' || SQLERRM);
        null;
end;
/
