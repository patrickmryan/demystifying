#require 'sqlite3'

class ApplicationController < ActionController::Base
  def hello_world
    #self.render(plain: 'Hello World')
    #self.render(inline: '<em>Hello, World</em>')
    #self.render('application/hello_world')

    aName = params['name'] || 'Default'
    self.render('application/hello_world', locals: {name: aName})

  end

  def list_posts
    connection = self.get_connection

    results = connection.execute('select * from posts')
    render 'application/list_posts', locals: { posts: results }
  end

  def show_post
    connection = self.get_connection
    results = connection.execute('select * from posts where posts.id = ? limit 1',
      params['id'])
    render 'application/show_post', locals: { post: results.first }
  end

  def create_post
    connection = self.get_connection

    insert_query = <<-SQL
      INSERT INTO posts (title, body, author, created_at)
      VALUES (?, ?, ?, ?)
    SQL

    connection.execute(insert_query,
      params['title'],
      params['body'],
      params['author'],
      Date.current.to_s)

    redirect_to '/list_posts'

  end

  def edit_post
    connection = self.get_connection
    result = connection.execute("SELECT * FROM posts WHERE posts.id = ? LIMIT 1", params['id']).first

    render 'application/edit_post', locals: { post: result }

  end


  def update_post
    connection = self.get_connection

    update_query = <<-SQL
      UPDATE posts
      SET title      = ?,
          body       = ?,
          author     = ?
      WHERE posts.id = ?
    SQL
    connection.execute update_query, params['title'], params['body'], params['author'], params['id']

    redirect_to '/list_posts'
  end


  def get_connection
    connection = SQLite3::Database.new 'db/development.sqlite3'
    connection.results_as_hash = true
    connection
  end

end
