create or replace package body payment_api_pack
is

  -- Создание платежа
  function create_payment(p_payment_data   t_payment_detail_array,
                          p_summa          payment.summa%type,
                          p_currency_id    payment.currency_id%type,
                          p_from_client_id payment.from_client_id%type,
                          p_to_client_id   payment.to_client_id%type,
                          p_payment_date   payment.create_dtime%type
                          ) return payment.payment_id%type 
  is
    v_payment_id payment.payment_id%type;
    v_msg varchar2(250 char) := 'Платеж создан. Статус: ' || c_status_created;
  begin
    dbms_output.put_line('Дата платежа: ' || to_char(p_payment_date, 'dd mon year'));
    
    if p_payment_data is not empty then
      for i in p_payment_data.first..p_payment_data.last loop
        if p_payment_data(i).field_type is null then
          dbms_output.put_line(c_err_msg_empty_field_id);
        end if;
        if p_payment_data(i).field_value is null then
          dbms_output.put_line(c_err_msg_empty_field_value);
        end if;
        dbms_output.put_line('field_type = ' || p_payment_data(i).field_type || ', field_value = ' || p_payment_data(i).field_value );
      end loop;
    else
      dbms_output.put_line(c_err_msg_empty_collection);
    end if;
    
    -- добавление платежа
    insert into payment(payment_id, create_dtime, summa, currency_id, from_client_id, to_client_id)
      values(payment_seq.nextval, p_payment_date, p_summa, p_currency_id, p_from_client_id, p_to_client_id)
      returning payment_id into v_payment_id;
    
    -- добавление деталей платежа из коллекции
    insert into payment_detail(payment_id, field_id, field_value)
      select v_payment_id, value(t).field_type, value(t).field_value from table(p_payment_data) t; 
    
    dbms_output.put_line(v_msg);
    dbms_output.put_line('v_payment_id = ' || v_payment_id);
    
    return v_payment_id;
  end create_payment;

  -- Сброс платежа в "ошибочный статус" с указанием причины
  procedure fail_payment(p_payment_id payment.payment_id%type,
                         p_reason     payment.status_change_reason%type
                         )
  is
    v_date date := sysdate;
    v_msg varchar2(250 char) := 'Сброс платежа в "ошибочный статус" с указанием причины. Статус: ' || c_status_error || '. Причина: ' || p_reason;
  begin
    dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd FMmonth (dy)'));
    dbms_output.put_line(v_msg);

    dbms_output.put_line('p_payment_id = ' || p_payment_id);
    if p_payment_id is null then
      dbms_output.put_line(c_err_msg_empty_object_id);
    end if;

      if p_reason is null then
      dbms_output.put_line(c_err_msg_empty_reason);
    end if;
      
    update payment
       set status = c_status_error,
           status_change_reason = p_reason
     where payment_id = p_payment_id 
       and status = c_status_created; 
    
    dbms_output.put_line(sql%rowcount);
  end fail_payment;


  -- Отмена платежа с указанием причины
  procedure cancel_payment(p_payment_id payment.payment_id%type,
                           p_reason     payment.status_change_reason%type
                           )
  is
    v_date date := sysdate;
    v_msg varchar2(250 char) := 'Отмена платежа с указанием причины. Статус: ' || c_status_canceled || '. Причина: ' || p_reason;
  begin
    dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd.FMRM.yyyy'));
    dbms_output.put_line(v_msg);

    if p_payment_id is null then
      dbms_output.put_line(c_err_msg_empty_object_id);
    end if;
    dbms_output.put_line('p_payment_id = ' || p_payment_id);

      if p_reason is null then
      dbms_output.put_line(c_err_msg_empty_reason);
    end if;
      
    update payment
       set status = c_status_canceled,
           status_change_reason = p_reason
     where payment_id = p_payment_id 
       and status = c_status_created; 
  end cancel_payment;

  -- Успешное завершение платежа
  procedure successful_finish_payment(p_payment_id payment.payment_id%type)
  is
    v_date date := sysdate;
    v_msg varchar2(250 char) := 'Успешное завершение платежа. Статус: ' || c_status_finished;
  begin
    dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd.mm.yy hh24:mi:ss'));
    dbms_output.put_line(v_msg);

    dbms_output.put_line('p_payment_id = ' || p_payment_id);
    if p_payment_id is null then
      dbms_output.put_line(c_err_msg_empty_object_id);
    end if;
      
    update payment
       set status = c_status_finished,
            status_change_reason = ''
     where payment_id = p_payment_id 
       and status = c_status_created; 
  end successful_finish_payment;
    
end payment_api_pack;
/
