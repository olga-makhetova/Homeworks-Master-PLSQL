/*
  �����: �������� �����
  �������� ������: API ��� ��������� �������
*/

create or replace package payment_api_pack
is
  -- ������� �������
  c_status_created  constant payment.status%type := 0;
  c_status_finished constant payment.status%type := 1;
  c_status_error    constant payment.status%type := 2;
  c_status_canceled constant payment.status%type := 3;

 -- ��������� �� �������
 c_err_msg_empty_collection  constant varchar2(250 char) := '��������� �� �������� ������'; 
 c_err_msg_empty_field_id    constant varchar2(250 char) := 'ID ���� �� ����� ���� ������'; 
 c_err_msg_empty_field_value constant varchar2(250 char) := '�������� � ���� �� ����� ���� ������';  
 c_err_msg_empty_object_id   constant varchar2(250 char) := 'ID ������� �� ����� ���� ������';  
 c_err_msg_empty_reason      constant varchar2(250 char) := '������� �� ����� ���� ������';

  -- �������� �������
  function create_payment(p_payment_data   t_payment_detail_array,
                          p_summa          payment.summa%type,
                          p_currency_id    payment.currency_id%type,
                          p_from_client_id payment.from_client_id%type,
                          p_to_client_id   payment.to_client_id%type,
                          p_payment_date   payment.create_dtime%type
                          ) return payment.payment_id%type;
  
  -- ����� ������� � "��������� ������" � ��������� �������
  procedure fail_payment(p_payment_id payment.payment_id%type,
                         p_reason     payment.status_change_reason%type
                         );
  
  -- ������ ������� � ��������� �������
  procedure cancel_payment(p_payment_id payment.payment_id%type,
                           p_reason     payment.status_change_reason%type
                           );
  
  -- �������� ���������� �������
  procedure successful_finish_payment(p_payment_id payment.payment_id%type);      
  

end payment_api_pack;
/
