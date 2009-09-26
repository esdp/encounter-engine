Given /пользователем (.*) создана игра "(.*)"$/ do |user_name, game_name|
  Допустим %{я зарегистрирован как #{user_name}}
  И %{#{user_name} создаёт игру "#{game_name}"}
end

Given /^создана игра "(.*)"$/ do |game_name|
  author_name = 'Author'
  Допустим %{пользователем #{author_name} создана игра "#{game_name}"}
end

Given /(.*) создаёт игру "(.*)"$/ do |user_name, game_name|
  Допустим %{я логинюсь как #{user_name}}
  Если %{я захожу в личный кабинет}
  Если %{иду по ссылке "Создать игру"}
  Если %{ввожу "#{game_name}" в поле "Название"}
  Если %{ввожу "#{game_name}" в поле "Описание"}
  Если %{нажимаю "Создать"}
  То %{должен быть перенаправлен в профиль игры "#{game_name}"}
end

Given %r{(.*) назначает начало игры "(.*)" на "(.*)"} do |user_name, game_name, datetime|
  Допустим %{Я логинюсь как #{user_name}}
  Если %{захожу в профиль игры "#{game_name}"}
  Если %{иду по ссылке "Редактировать эту игру"}
  Если %{ввожу "#{datetime}" в поле "Начало игры"}
  Если %{нажимаю "Сохранить"}
  То %{должен быть перенаправлен в профиль игры "#{game_name}"}
  То %{должен увидеть "#{datetime}"}
end

Given /начало игры "(.*)" назначено на "(.*)"/ do |game_name, datetime|
  game = Game.find_by_name(game_name)
  author_name = game.author.nickname
  Допустим %{#{author_name} назначает начало игры "#{game_name}" на "#{datetime}"}
end

When %r{захожу в профиль игры "(.*)"$}i do |game_name|  
  game = Game.find_by_name(game_name)  
  То %{захожу по адресу #{resource(game)}}
end

When /захожу в список игр$/ do
  Если %{я захожу на главную страницу}
  Если %{иду по ссылке "Список игр"}
end

Then %r{должен быть перенаправлен в профиль игры "(.*)"$}i do |game_name|
  game = Game.find_by_name(game_name)
  То %{должен быть перенаправлен по адресу #{resource(game)}}
end