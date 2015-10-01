package entities;

import javax.persistence.*;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(schema="public", name="users")
public class User {

    @Id
    @GeneratedValue(strategy= GenerationType.SEQUENCE, generator="users_gen")
    @SequenceGenerator(name="users_gen", sequenceName="users_id_seq")
    private Integer id;

    @Column(name="email", nullable=false, length=50)
    private String email;

    @Column
    private String name;

    @OneToMany(mappedBy = "user",  cascade = CascadeType.ALL)
    private List<Advertisment> advertisments = new ArrayList<>();

    @Column
    private String password;

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) throws Exception{
        this.password = password;
    }



    public User() {}

    public User(String email, String passHash) {

        this.email = email;
        this.password = passHash;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public List<Advertisment> getAdvertisments() {
        return advertisments;
    }

    public void setAdvertisments(List<Advertisment> advertisments) {
        this.advertisments = advertisments;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
