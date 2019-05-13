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
    render 'application/lists_posts', locals: { posts: results }
  end

  def show_post
    connection = self.get_connection
    results = connection.execute('select * from posts where posts.id = ? limit 1',
      params['id'])
    render 'application/show_post', locals: { post: results.first }
  end

  def get_connection
    connection = SQLite3::Database.new 'db/development.sqlite3'
    connection.results_as_hash = true
    connection
  end

end
