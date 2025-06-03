create or replace package body payment_api_pack
is
  g_is_api boolean := false;
  
  procedure allow_changes is
  begin
    g_is_api := true;
  end allow_changes;
  
  procedure disallow_changes is
  begin
    g_is_api := false;
  end disallow_changes;

  -- Создание платежа
  function create_payment(p_payment_data   t_payment_detail_array,
                          p_summa          payment.summa%type,
                          p_currency_id    payment.currency_id%type,
                          p_from_client_id payment.from_client_id%type,
                          p_to_client_id   payment.to_client_id%type,
                          p_create_dtime   payment.create_dtime%type
                          ) return payment.payment_id%type 
  is
    v_payment_id payment.payment_id%type;
    v_msg varchar2(250 char) := 'Платеж создан. Статус: ' || c_status_created;
  begin
    allow_changes();
    dbms_output.put_line('Дата платежа: ' || to_char(p_create_dtime, 'dd mon year'));
    
    -- добавление платежа
    insert into payment(payment_id, create_dtime, summa, currency_id, from_client_id, to_client_id)
      values(payment_seq.nextval, p_create_dtime, p_summa, p_currency_id, p_from_client_id, p_to_client_id)
      returning payment_id into v_payment_id;
    
    -- добавление деталей платежа
    payment_detail_api_pack.insert_or_update_payment_detail(v_payment_id, p_payment_data);
    
    dbms_output.put_line(v_msg);
    dbms_output.put_line('v_payment_id = ' || v_payment_id);
    
    disallow_changes();
    return v_payment_id;
  exception
    when others then
      disallow_changes();
      raise;
  end create_payment;

  -- Сброс платежа в "ошибочный статус" с указанием причины
  procedure fail_payment(p_payment_id payment.payment_id%type,
                         p_reason     payment.status_change_reason%type
                         )
  is
    v_date date := sysdate;
    v_msg varchar2(250 char) := 'Сброс платежа в "ошибочный статус" с указанием причины. Статус: ' || c_status_error || '. Причина: ' || p_reason;
  begin
    allow_changes();
    dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd FMmonth (dy)'));
    dbms_output.put_line(v_msg);

    if p_payment_id is null then
      raise_application_error(c_error_code_invalid_input_parameter, c_err_msg_empty_object_id);
    end if;
    dbms_output.put_line('p_payment_id = ' || p_payment_id);

    if p_reason is null then
      raise_application_error(c_error_code_invalid_input_parameter, c_err_msg_empty_reason);
    end if;
      
    update payment
       set status = c_status_error,
           status_change_reason = p_reason
     where payment_id = p_payment_id 
       and status = c_status_created; 
    
    dbms_output.put_line(sql%rowcount);
    disallow_changes();
  exception
    when others then
      disallow_changes();
      raise;
  end fail_payment;


  -- Отмена платежа с указанием причины
  procedure cancel_payment(p_payment_id payment.payment_id%type,
                           p_reason     payment.status_change_reason%type
                           )
  is
    v_date date := sysdate;
    v_msg varchar2(250 char) := 'Отмена платежа с указанием причины. Статус: ' || c_status_canceled || '. Причина: ' || p_reason;
  begin
    allow_changes();
    dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd.FMRM.yyyy'));
    dbms_output.put_line(v_msg);

    if p_payment_id is null then
      raise_application_error(c_error_code_invalid_input_parameter, c_err_msg_empty_object_id);
    end if;
    dbms_output.put_line('p_payment_id = ' || p_payment_id);

    if p_reason is null then
      raise_application_error(c_error_code_invalid_input_parameter, c_err_msg_empty_reason);
    end if;
      
    update payment
       set status = c_status_canceled,
           status_change_reason = p_reason
     where payment_id = p_payment_id 
       and status = c_status_created; 
    disallow_changes();
  exception
    when others then
      disallow_changes();
      raise;
  end cancel_payment;

  -- Успешное завершение платежа
  procedure successful_finish_payment(p_payment_id payment.payment_id%type)
  is
    v_date date := sysdate;
    v_msg varchar2(250 char) := 'Успешное завершение платежа. Статус: ' || c_status_finished;
  begin
    allow_changes();
    dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd.mm.yy hh24:mi:ss'));
    dbms_output.put_line(v_msg);

    if p_payment_id is null then
      raise_application_error(c_error_code_invalid_input_parameter, c_err_msg_empty_object_id);
    end if;
    dbms_output.put_line('p_payment_id = ' || p_payment_id);
      
    update payment
       set status = c_status_finished,
            status_change_reason = ''
     where payment_id = p_payment_id 
       and status = c_status_created; 
       
    disallow_changes();
  exception
    when others then
      disallow_changes();
      raise;
  end successful_finish_payment;
  
  procedure is_changes_through_api is
  begin
    if not g_is_api then
      raise_application_error(c_error_code_manual_changes, c_err_msg_manual_changes);
    end if;
  end;
    
end payment_api_pack;
/
