package com.example.backend.dao;

import com.example.backend.model.BlogCategory;
import com.example.backend.model.BlogPost;
import com.example.backend.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BlogDAO {
    
    public List<BlogPost> getAllPosts(){
        List<BlogPost> list = new ArrayList<>();
        String sql = "select * from blog_posts order by created_at desc";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pre = con.prepareStatement(sql);
             ResultSet re = pre.executeQuery()){
            while(re.next()){
                BlogPost p = new BlogPost();
                p.setId(re.getInt("id"));
                p.setTitle(re.getString("title"));
                p.setContent(re.getString("content"));
                p.setFeaturedImageUrl(re.getString("featured_image_url")); 
                p.setCategoryId(re.getInt("category_id"));
                p.setFeatured(re.getBoolean("is_featured"));
                p.setCreatedAt(re.getTimestamp("created_at"));
                p.setUpdatedAt(re.getTimestamp("updated_at"));
                list.add(p);
            }

        }catch (Exception e){
            e.printStackTrace();
        }
        return list;
    }

    
    public List<BlogPost> getFeaturedPosts(int limit){
        List<BlogPost> list = new ArrayList<>();
        String sql = "SELECT * FROM blog_posts WHERE is_featured = 1 ORDER BY created_at DESC LIMIT ?";

        try (Connection con = DBConnection.getConnection();
            PreparedStatement pre = con.prepareStatement(sql)){
            pre.setInt(1,limit);
            ResultSet re = pre.executeQuery();
            while(re.next()){
                BlogPost p = new BlogPost();
                p.setId(re.getInt("id"));
                p.setTitle(re.getString("title"));
                p.setContent(re.getString("content"));
                p.setFeaturedImageUrl(re.getString("featured_image_url")); 
                p.setCategoryId(re.getInt("category_id"));
                p.setFeatured(re.getBoolean("is_featured"));
                p.setCreatedAt(re.getTimestamp("created_at"));
                p.setUpdatedAt(re.getTimestamp("updated_at"));
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    
    public List<BlogCategory> getAllCategories() {
        List<BlogCategory> list = new ArrayList<>();
        String sql = "SELECT id, name, type FROM blog_categories";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new BlogCategory(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("type")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
