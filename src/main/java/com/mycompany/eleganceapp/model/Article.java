package com.mycompany.eleganceapp.model;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "Article")
@NamedQueries({
        @NamedQuery(name = "Article.findAll", query = "SELECT a FROM Article a"),
        @NamedQuery(name = "Article.findByCategory", query = "SELECT a FROM Article a WHERE a.category.name = :categoryName")
})
public class Article implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(length = 2000)
    private String description;

    private Double price;

    @Column(length = 500)
    private String imageUrl;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "category_id")
    private Category category;

    @Column(columnDefinition = "BOOLEAN DEFAULT true")
    private Boolean enabled = true;

    // Constructors
    public Article() {
    }

    public Article(String name, String description, Double price, String imageUrl, Category category) {
        this.name = name;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.category = category;
    }

    // ===== Getters & Setters =====
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Boolean getEnabled() {
        return enabled == null ? true : enabled;
    }

    public void setEnabled(Boolean enabled) {
        this.enabled = enabled;
    }
}
