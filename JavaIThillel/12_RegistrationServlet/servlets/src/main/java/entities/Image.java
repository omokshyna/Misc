package entities;

import javax.persistence.*;

@Entity
@Table(schema = "public", name = "images")
public class Image {

    @Id
    @GeneratedValue(strategy= GenerationType.SEQUENCE, generator="i_gen")
    @SequenceGenerator(name="i_gen", sequenceName="i_id_seq")
    private Integer id;

    @Column
    private String description;

}
