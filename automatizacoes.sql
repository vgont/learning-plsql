create or replace trigger tr_id_motoristas
before insert on motoristas
for each row
declare
	v_id motoristas.id%type;
begin
	select sq_id_motoristas.nextval into v_id from dual;
	:new.id := v_id; 
end;

create or replace trigger tr_id_cnhs
before insert on cnhs
for each row
declare
	v_id cnhs.id%type;
begin
	select sq_id_cnhs.nextval into v_id from dual;
	:new.id := v_id; 
end;

create or replace trigger tr_id_veiculos
before insert on veiculos
for each row
declare
	v_id veiculos.id%type;
begin
	select sq_id_veiculos.nextval into v_id from dual;
	:new.id := v_id; 
end;

create or replace trigger tr_id_ruas
before insert on ruas
for each row
declare
	v_id ruas.id%type;
begin
	select sq_id_ruas.nextval into v_id from dual;
	:new.id := v_id; 
end;

create or replace trigger tr_id_acidentes
before insert on acidentes
for each row
declare
	v_id acidentes.id%type;
begin
	select sq_id_acidentes.nextval into v_id from dual;
	:new.id := v_id; 
end;

create or replace trigger tr_id_multas
before insert on multas
for each row
declare
	v_id multas.id%type;
begin
	select sq_id_multas.nextval into v_id from dual;
	:new.id := v_id; 
end;

create or replace trigger tr_multa_causador_acidente
after insert on acidentes
for each row
declare
    v_id_causador_acidente acidentes.id_causador%type;
    v_descricao_acidente acidentes.descricao%type;
    v_id_veiculo_causador_acidente motoristas.id_veiculo%type;
begin
    v_id_causador_acidente := :new.id_causador;
    v_descricao_acidente := :new.descricao;
    v_id_veiculo_causador_acidente := :new.id_veiculo_causador;
    
    if v_id_causador_acidente is not null then

        select id_veiculo into v_id_veiculo_causador_acidente
        from motoristas
        where id_motorista = v_id_causador_acidente;

        insert into multas(id_motorista, id_veiculo, descricao, valor, dt_inicio, dt_vencimento, dt_pagamento)
        values(v_id_causador_acidente, v_id_veiculo_causador_acidente, v_descricao_acidente, 150, sysdate, (sysdate + 60), null);
    end if;
end;

create or replace trigger tr_remocao_pontos_motorista_multa
after insert on multas
for each row
declare
    v_id_motorista_multado multas.id_motorista%type;
    v_pontos_adicionados multas.pontos%type;
begin
    v_id_motorista_multado := :new.id_motorista;
    v_pontos_adicionados := 4;

    update cnhs 
    set pontos = pontos + v_pontos_adicionados
    where id_motorista = v_id_motorista_multado;
end;

create or replace function fn_verificar_limite_pontos_chn (
    p_id_motorista in motoristas.id_motorista%type
)
return number
is
    v_tipo_cnh cnhs.tp_cnh%type;
    p_limite_pontos int;
begin
    select tp_cnh into v_tipo_cnh
    from cnhs
    where id_motorista = p_id_motorista;

    if v_tipo_cnh = 'trabalho' then
        p_limite_pontos := 40;

    else 
        p_limite_pontos :=20;

    end if;
    return p_limite_pontos;
end;

create or replace trigger tr_adicionar_pontos_cnh
before update cnh
for each row
declare
    v_pontos_atuais motoristas.pontos%type;
    v_pontos_maximos constant int;
    v_pontos_para_adicionar int;
    v_soma_pontos int;
begin
    v_pontos_maximos := fn_verificar_limite_pontos_cnh(p_id_motorista);

    v_pontos_atuais := :new.pontos;
    v_soma_pontos := v_pontos_atuais + v_pontos_para_adicionar;

    if v_soma_pontos >= v_pontos_maximos then
        :new.pontos = v_pontos_maximos;        

    else
        :new.pontos = v_soma_pontos;
    end if;
end;

create or replace procedure pr_verificar_vencimento_multa is
begin
    for r in (
        select * from multas 
        where dt_vencimento < trunc(sysdate)
    ) loop

        insert into multas(id_motorista, id_veiculo, descricao, valor, dt_inicio, dt_vencimento, dt_pagamento)
        values(r.id_motorista, r.id_veiculo, 'motorista não pagou uma multa', (r.valor + 50), sysdate, (sysdate + 30), null);
    end loop;
end;

begin
    dbms_scheduler.create_job (
        job_name        => 'verificar datas de vencimento de multas',
        job_type        => 'plsql_block',
        job_action      => 'begin pr_verificar_vencimento_multa; end;',
        start_date      => systimestamp,
        repeat_interval => 'freq=daily; byhour=0; byminute=0; bysecond=0;',
        enabled         => true
    );
end;
/
