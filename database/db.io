Table users {
  id uuid [pk]
  username varchar [unique, not null]
  email varchar [unique, not null]
  password_hash varchar [not null]
  avatar_media_id uuid [ref: < medias.id]
  bio text
  created_at timestamp [not null]
  updated_at timestamp [not null]
  deleted_at timestamp
}

Table posts {
  id uuid [pk]
  author_id uuid [not null, ref: > users.id]
  location_id uuid [not null, ref: > locations.id]
  title varchar
  text text [not null]
  like_count int64 [not null, default: 0]
  view_count int64 [not null, default: 0]
  created_at timestamp [not null]
  updated_at timestamp [not null]
  deleted_at timestamp
  
  indexes {
    author_id
    location_id
    created_at
  }
}

Table medias {
  id uuid [pk]
  storage_key varchar [not null, note: 'S3 object key']
  bucket varchar [not null, note: 'S3 bucket name']
  mime_type varchar [not null]
  width int
  height int
  created_at timestamp [not null]

  Note: 'Медиа-файлы хранятся в S3. БД хранит только метаданные.'
}

Table posts2media {
  post_id uuid [not null, ref: > posts.id ]
  media_id uuid [not null, ref: > medias.id]
  created_at timestamp [not null]
  
  indexes {
    (post_id, media_id) [pk]
  }
}

Table comments {
  id uuid [pk]
  post_id uuid [not null, ref: > posts.id]
  author_id uuid [not null, ref: > users.id]
  text text [not null]
  like_count int64 [not null, default: 0]
  created_at timestamp [not null]
  updated_at timestamp [not null]
  deleted_at timestamp
  
  indexes {
    author_id
    post_id
    created_at
  }
}

Enum reaction_type {
  like
  dislike
}

Table posts_reactions {
  user_id uuid [not null, ref: > users.id]
  post_id uuid [not null, ref: > posts.id]
  type reaction_type [not null]
  created_at timestamp [not null]

  indexes {
    (user_id, post_id) [pk]
    post_id
  }
}

Table comments_reactions {
  user_id uuid [not null, ref: > users.id]
  comment_id uuid [not null, ref: > comments.id]
  type reaction_type [not null]
  created_at timestamp [not null]

  indexes {
    (user_id, comment_id) [pk]
    comment_id
  }
}

Table locations {
  id uuid [pk]
  title varchar [not null]
  description text [not null]
  lat float64
  lon float64
}

Table locations2medias {
  location_id uuid [not null, ref: > locations.id]
  media_id uuid [not null, ref: > medias.id]
  created_at timestamp [not null]

  indexes {
    (location_id, media_id) [pk]
    location_id
  }
}

Table follows {
  follower_id uuid [not null, ref: > users.id]
  followee_id uuid [not null, ref: > users.id]
  created_at timestamp [not null]

  indexes {
    (follower_id, followee_id) [pk]
    follower_id
    followee_id
  }
}
