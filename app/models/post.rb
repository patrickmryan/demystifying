class Post
  attr_reader :id, :title, :body, :author, :created_at

  def initialize(attributes={})
    @id = attributes['id']
    @title = attributes['title']
    @body = attributes['body']
    @author = attributes['author']
    @created_at = attributes['created_at']
  end

  def save
    insert_query = <<-SQL
      INSERT INTO posts (title, body, author, created_at)
      VALUES (?, ?, ?, ?)
    SQL

    self.connection.execute insert_query,
      title,
      body,
      author,
      Date.current.to_s
  end

  # ...

  def connection
    db_connection = SQLite3::Database.new('db/development.sqlite3')
    db_connection.results_as_hash = true
    db_connection
  end

end
