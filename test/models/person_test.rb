require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  setup do
  	@person = people(:admin)
  end

  test "tem que ser valido sem alterações" do
  	assert @person.valid?
  end
  
  test "não pode ter nome vazio" do
  	@person.name = ""
  	assert !@person.valid?
  end
  
  test "não pode ter nome maior que 50 caracteres" do
  	@person.name = "*"*51
  	assert !@person.valid?
  end

  test "pode ter email vazio" do
  	@person.email = ""
  	assert @person.valid?
  end

  test "não pode ter email inválido" do
  	@person.email = "foo@bar"
  	assert !@person.valid?
  end

  test "não pode ter email repetido" do
  	new_person = Person.new(@person.attributes)
  	assert !new_person.valid?
  end

  test "a data de nascimento não pode ser menor que 16 anos" do
	@person.born_at = Date.today - 15.years
	assert !@person.valid? 	
  end

  test "a data de nascimento pode ser maior que 16 anos" do
  	@person.born_at = Date.today - 17.years
  	assert @person.valid? 
  end

  test "tem que retornar a senha criptografada correta" do
  	assert_equal Digest::SHA1.hexdigest("123_test_456"), Person.encrypt_password("test")
  end

  test "tem que ter atributo para receber a senha em texto puro" do
  	assert_respond_to @person, :plain_password=
  end

  test "tem que ter atributo para retornar a senha em texto puro como vazia" do
  	assert_respond_to @person, :plain_password
  	assert_nil @person.plain_password
  end
  	
  test "tem que gravar a senha encriptografada no atributo password" do
  	@person.plain_password = "teste"
  	@person.save
  	assert_equal Person.encrypt_password("teste"), @person.password
  end

  test "nao deve alterar a senha encriptografada se enviada senha em texto puro vazia" do
  	@person.plain_password = "teste"
  	old_encrypted = @person.password
  	@person.plain_password = ""
  	@person.save
  	assert_equal old_encrypted, @person.password
  end
  
end
