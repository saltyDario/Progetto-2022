package GUI;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JPanel;
import javax.swing.border.LineBorder;

import DAO.AggiungiDAO;
import DAO.AscoltoDAO;
import DAO.LibreriaDAO;
import DAO.TracciaDAO;
import ImplementazioniPostgresDAO.GetAggiungiDAO;
import ImplementazioniPostgresDAO.GetAscoltoDAO;
import ImplementazioniPostgresDAO.GetTracceDAO;
import ImplementazioniPostgresDAO.GetLibreriaDAO;
import Modelli.Libreria;
import Modelli.Playlist;

import java.awt.Color;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

import java.awt.Font;
import java.awt.Image;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;
import java.sql.Timestamp;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import javax.swing.SwingConstants;
import javax.swing.DefaultComboBoxModel;
import javax.swing.ImageIcon;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JComboBox;

/**
 * Classe GUI che permette di ascoltare una traccia o di aggiungerla ad una playlist.
 */
public class AscoltoAggiungiTraccia extends JDialog {
 
	/** Posizione X,Y del mouse sullo schermo. */
	private int mouseX, mouseY;
	
	/** Timestamp del tempo attuale */
	private Timestamp ts = new Timestamp(System.currentTimeMillis());
	
	/** Lista di playlist su cui � possibile aggiungere tracce. */
	private ArrayList<Playlist> lista_playlist = new ArrayList<Playlist>();
	
	/** TLibreria dell'utente. */
	private Libreria libs;
	//yyyy/MM/dd HH:mm:ss

	/**
	 * Costruttore della classe AscoltoAggiungiTraccia.
	 *
	 * @param id_utente passato per effettuare i lavori di ascolto e aggiunta
	 * @param id_traccia passato per effettuare i lavori di ascolto e aggiunta
	 * @param nome_traccia passato per effettuare i lavori di ascolto e aggiunta
	 */
	public AscoltoAggiungiTraccia(int id_utente, int id_traccia, String nome_traccia) {
		
		LibreriaDAO l = new GetLibreriaDAO();
		libs = l.ritornaLibreria(id_utente);
		lista_playlist = libs.getPlaylist();
		if(lista_playlist.size() == 0) {
			Playlist dummyPl = new Playlist(0, "Select", null, 0);
			lista_playlist.add(dummyPl);
		}
		int grandezza = lista_playlist.size();
		
		JComboBox playlistBox = new JComboBox<Playlist>();
		playlistBox.setBorder(new LineBorder(Color.BLACK, 2, true));
		playlistBox.setModel(new DefaultComboBoxModel<Playlist>(lista_playlist.toArray(new Playlist[0])));
		playlistBox.setBounds(248, 109, 176, 53);
		
		JPanel contentPanel = new JPanel();
		contentPanel.add(playlistBox);
		contentPanel.setBackground(Color.GRAY);
		JDialog trackHearAdd = new JDialog();
		trackHearAdd.getContentPane().setBackground(Color.WHITE);
		trackHearAdd.setResizable(false);
		trackHearAdd.setDefaultCloseOperation(JDialog.DISPOSE_ON_CLOSE);
		trackHearAdd.setTitle("Aggiungi Playlist.");
		trackHearAdd.setUndecorated(true);
		trackHearAdd.setBounds(100, 100, 450, 300);
		trackHearAdd.getContentPane().setLayout(null);
		trackHearAdd.setVisible(true);
		contentPanel.setBounds(0, 0, 450, 300);
		contentPanel.setBorder(new LineBorder(Color.BLACK, 2, true));
		trackHearAdd.getContentPane().add(contentPanel);
		contentPanel.setLayout(null);
		{
			JPanel draggablePanel = new JPanel();
			draggablePanel.addMouseMotionListener(new MouseMotionAdapter() {
				@Override
				public void mouseDragged(MouseEvent e) {
					trackHearAdd.setLocation(trackHearAdd.getX() + e.getX() - mouseX, trackHearAdd.getY() + e.getY() - mouseY);
				}
			});
			draggablePanel.addMouseListener(new MouseAdapter() {
				@Override
				public void mousePressed(MouseEvent e) {
					mouseX = e.getX();
					mouseY = e.getY();
				}
			});
			draggablePanel.setLayout(null);
			draggablePanel.setBackground(Color.BLACK);
			draggablePanel.setBounds(0, 0, 450, 20);
			contentPanel.add(draggablePanel);
			{
				JLabel exitButton = new JLabel("");
				exitButton.setIcon(new ImageIcon(new ImageIcon(getClass().getResource("/Immagini/closered.png")).getImage().getScaledInstance(15, 15, Image.SCALE_SMOOTH)));
				exitButton.setBounds(420, 0, 30, 20);
				draggablePanel.add(exitButton);
				exitButton.setHorizontalAlignment(SwingConstants.CENTER);
				exitButton.setForeground(Color.WHITE);
				exitButton.addMouseListener(new MouseAdapter() {
					@Override
					public void mouseClicked(MouseEvent e) {
							trackHearAdd.dispose();
						}
				});
				exitButton.setFont(new Font("Arial", Font.BOLD, 16));
			}
		}
		
		JPanel panel_Title = new JPanel();
		panel_Title.setLayout(null);
		panel_Title.setBorder(new LineBorder(Color.BLACK, 2, true));
		panel_Title.setBackground(Color.GRAY);
		panel_Title.setBounds(52, 22, 347, 57);
		contentPanel.add(panel_Title);
		
		JLabel lblTitle = new JLabel("Traccia: "+ nome_traccia);
		lblTitle.setHorizontalAlignment(SwingConstants.CENTER);
		lblTitle.setForeground(Color.WHITE);
		lblTitle.setFont(new Font("Arial", Font.BOLD, 29));
		lblTitle.setBounds(8, 10, 331, 35);
		panel_Title.add(lblTitle);
		
		JButton btnListen = new JButton("Ascolta");
		btnListen.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				boolean ok;

				Timestamp data = ts;
				String fasciaoraria = null;
				
				LocalTime orario = java.time.LocalTime.now();
				LocalTime mattina = LocalTime.parse("07:00:00");
				LocalTime pomeriggio = LocalTime.parse("13:59:59");
				LocalTime sera = LocalTime.parse("18:59:59");
				LocalTime notte = LocalTime.parse("23:59:59");
				
				LocalTime notteFonda = LocalTime.parse("00:00:00");
				LocalTime notteFin = LocalTime.parse("06:59:59");
				
				AscoltoDAO a = new GetAscoltoDAO();
				
				if(orario.isAfter(mattina) && orario.isBefore(pomeriggio)) {
					fasciaoraria = "Mattina";
				}else if(orario.isAfter(pomeriggio) && orario.isBefore(sera)) {
					fasciaoraria = "Pomeriggio";
				}else if(orario.isAfter(sera) && orario.isBefore(notte)) {
					fasciaoraria = "Sera";
				}else if(orario.isAfter(notteFonda) && orario.isBefore(notteFin)) {
					fasciaoraria = "Notte";
				}

				ok = a.inserisciAscolto(id_utente, id_traccia, fasciaoraria, data);
				
				if(ok == true) {
					JOptionPane.showMessageDialog(null, "La traccia "+ nome_traccia +" e' stata ascoltata.");
					trackHearAdd.dispose();
				}
			}
		});
		btnListen.setToolTipText("Ascolta la canzone.");
		btnListen.setBorder(new LineBorder(Color.BLACK, 2, true));
		btnListen.setBackground(Color.WHITE);
		btnListen.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				btnListen.setBackground(Color.DARK_GRAY);
			}
			@Override
			public void mouseExited(MouseEvent e) {
				btnListen.setBackground(Color.WHITE);	
			}
		});
		btnListen.setBounds(52, 190, 126, 57);
		contentPanel.add(btnListen);
		
		JButton btnAdd = new JButton("Add");
		btnAdd.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				boolean ok = false;
				int id_playlist = lista_playlist.get(playlistBox.getSelectedIndex()).getIDPlaylist();
				
				if(lista_playlist.get(0).getNomePlaylist().equals("Select")) {
					JOptionPane.showMessageDialog(null, "Non hai creato alcuna playlist, creane una.");
				}else {
					AggiungiDAO t = new GetAggiungiDAO();
					ok = t.inserisciTracciaInPlaylist(id_playlist, id_traccia);
						
					if(ok == true) {
						JOptionPane.showMessageDialog(null, "La traccia "+ nome_traccia +" e' stata aggiunta dalla playlist.");
						trackHearAdd.dispose();
					}
				}

			}
		});
		btnAdd.setToolTipText("Aggiungi la canzone dalla playlist.");
		btnAdd.setBorder(new LineBorder(Color.BLACK, 2, true));
		btnAdd.setBackground(Color.WHITE);
		btnAdd.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				btnAdd.setBackground(Color.DARK_GRAY);
			}
			@Override
			public void mouseExited(MouseEvent e) {
				btnAdd.setBackground(Color.WHITE);	
			}
		});
		btnAdd.setBounds(273, 190, 126, 57);
		contentPanel.add(btnAdd);
		
	}
}
