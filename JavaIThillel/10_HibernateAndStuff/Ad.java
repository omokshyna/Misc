package entities;

import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.sql.Date;
import java.util.Set;

/**
 * Created by meg on 10.05.14.
 */
@Entity
@Table(schema="public", name = "ads")
public class Ad {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Integer id;

    @Column(name = "title", nullable = false, length = 200)
    private String title;

    @Column(name = "date")
    @Type(type = "date")
    private Date adsDate;

    @Column(name = "content")
    @Type(type = "text")
    private String content;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "user_id")
    private User user;


    public Ad() {

    }

    @Override
    public String toString() {
        return String.format("Ad[%s, %s, %s]", title, content,user.getId());
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User getUser() {
        return this.user;
    }

    public void setUser(User u){
        this.user = u;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getDate() {
        return adsDate;
    }

    public void setAdsDate() {
        this.adsDate = new Date(new java.util.Date().getTime());
    }




}
