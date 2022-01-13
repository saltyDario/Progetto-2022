package Modelli;

import java.util.Date;

/**
 * Classe modello Artista.
 */
public class Artista {
	
	/** The id artista. */
	int id_artista;
	
	/** The nome artista. */
	String nome_artista;
	
	/** The datanascita artista. */
	Date datanascita_artista;
	
	/** The nazionalitÓ. */
	String nazionalitÓ;
	
	/**
	 * Instantiates a new artista.
	 *
	 * @param nomeArtista the nome artista
	 * @param datanascitaArtista the datanascita artista
	 * @param NazionalitÓ the nazionalitÓ
	 */
	public Artista(String nomeArtista, Date datanascitaArtista, String NazionalitÓ) {
		nome_artista = nomeArtista;
		datanascita_artista = datanascitaArtista;
		nazionalitÓ = NazionalitÓ;
	}
	
	/**
	 * Gets the nome artista.
	 *
	 * @return the nome artista
	 */
	public String getNomeArtista() {
		return nome_artista;
	}
	
	/**
	 * Gets the data nascita artista.
	 *
	 * @return the data nascita artista
	 */
	public Date getDataNascitaArtista() {
		return datanascita_artista;
	}
	
	/**
	 * Gets the nazionalitÓ artista.
	 *
	 * @return the nazionalitÓ artista
	 */
	public String getNazionalitÓArtista() {
		return nazionalitÓ;
	}
}
