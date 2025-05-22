create or replace package body payment_detail_api_pack
as
  -- Данные платежа добавлены или обновлены
  procedure insert_or_update_payment_detail(p_payment_id   payment.payment_id%type,
                                            p_payment_data t_payment_detail_array)
  is
    v_date date := sysdate;
    v_msg varchar2(250 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
  begin
    dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd.mm.yyyy hh:mi AM'));
    dbms_output.put_line(v_msg);

    dbms_output.put_line('p_payment_id = ' || p_payment_id);
    if p_payment_id is null then
      dbms_output.put_line(payment_api_pack.c_err_msg_empty_object_id);
    end if;
    
    if p_payment_data is not empty then
      for i in p_payment_data.first..p_payment_data.last loop
        if p_payment_data(i).field_type is null then
          dbms_output.put_line(payment_api_pack.c_err_msg_empty_field_id);
        end if;
        if p_payment_data(i).field_value is null then
          dbms_output.put_line(payment_api_pack.c_err_msg_empty_field_value);
        end if;
        dbms_output.put_line('field_type = ' || p_payment_data(i).field_type || ', field_value = ' || p_payment_data(i).field_value );
      end loop;
    else
      dbms_output.put_line(payment_api_pack.c_err_msg_empty_collection);
    end if;
    
    merge into payment_detail pd
      using (select * from table(p_payment_data)) v on (pd.payment_id = p_payment_id and pd.field_id = v.field_type)
      when matched then 
        update set pd.field_value = v.field_value
      when not matched then 
        insert (payment_id, field_id, field_value) values (p_payment_id, v.field_type, v.field_value);
  end insert_or_update_payment_detail;
  

  -- Детали платежа удалены
  procedure delete_payment_detail(p_payment_id         payment.payment_id%type,
                                  p_payment_delete_ids t_number_array)
  is
    v_date date := sysdate;
    v_msg varchar2(250 char) := 'Детали платежа удалены по списку id_полей';
  begin
    dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'DDD') || '''s day of year');
    dbms_output.put_line(v_msg);

    dbms_output.put_line('p_payment_id = ' || p_payment_id);
    if p_payment_id is null then
      dbms_output.put_line(payment_api_pack.c_err_msg_empty_field_id);
    end if;
    
    if p_payment_delete_ids is empty then
      dbms_output.put_line(payment_api_pack.c_err_msg_empty_collection);
    end if;
    dbms_output.put_line('Количество полей для удаления = ' || p_payment_delete_ids.count());
    
    forall i in p_payment_delete_ids.first..p_payment_delete_ids.last
      delete from payment_detail 
        where payment_id = p_payment_id 
          and field_id = p_payment_delete_ids(i);
  end delete_payment_detail;
  
end payment_detail_api_pack;
/
