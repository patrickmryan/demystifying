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
    # connection = self.get_connection
    # results = connection.execute('select * from posts')
    posts = Post.all
    render 'application/list_posts', locals: { posts: posts }
  end

  def show_post
    # connection = self.get_connection
    # result = find_post_by_id(params['id'])
    post = Post.find(params['id'])
    render 'application/show_post', locals: { post: post }

  end

  def create_post
    # connection = self.get_connection
    #
    # insert_query = <<-SQL
    #   INSERT INTO posts (title, body, author, created_at)
    #   VALUES (?, ?, ?, ?)
    # SQL
    #
    # connection.execute(insert_query,
    #   params['title'],
    #   params['body'],
    #   params['author'],
    #   Date.current.to_s)

    post = Post.new('title' => params['title'],
                    'body' => params['body'],
                    'author' => params['author'])
    post.save

    redirect_to '/list_posts'

  end

  def delete_post
#    self.get_connection.execute('delete from posts where posts.id = ?', params['id'])
    post = Post.find(params['id'])
    post.destroy
    redirect_to '/list_posts'

  end

  def edit_post
    # connection = self.get_connection
    # result = find_post_by_id(params['id'])

    post = Post.find(params['id'])
    render 'application/edit_post', locals: { post: post }

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

  # def find_post_by_id(id)
  #   self.get_connection.execute("SELECT * FROM posts WHERE posts.id = ? LIMIT 1", id).first
  # end


  def get_connection
    connection = SQLite3::Database.new 'db/development.sqlite3'
    connection.results_as_hash = true
    connection
  end

end
