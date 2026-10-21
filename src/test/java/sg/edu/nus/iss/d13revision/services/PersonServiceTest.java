package sg.edu.nus.iss.d13revision.services;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;
import java.util.stream.Collectors;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import sg.edu.nus.iss.d13revision.models.Person;

class PersonServiceTest {

    private PersonService personService;

    @BeforeEach
    void setUp() {
        personService = new PersonService();
    }

    @Test
    void constructor_initializesDefaultPersons() {
        List<Person> persons = personService.getPersons();

        assertEquals(2, persons.size());
        assertTrue(persons.stream().anyMatch(p -> p.getFirstName().equals("Mark") && p.getLastName().equals("Zuckerberg")));
        assertTrue(persons.stream().anyMatch(p -> p.getFirstName().equals("Elon") && p.getLastName().equals("Musk")));
    }

    @Test
    void addPerson_addsNewPersonToList() {
        Person person = new Person("Ada", "Lovelace");

        personService.addPerson(person);

        List<Person> persons = personService.getPersons();
        assertEquals(3, persons.size());
        assertTrue(persons.stream().anyMatch(p -> p.getFirstName().equals("Ada") && p.getLastName().equals("Lovelace")));
        assertNotNull(persons.stream()
                .filter(p -> p.getFirstName().equals("Ada") && p.getLastName().equals("Lovelace"))
                .findFirst()
                .orElseThrow()
                .getId());
    }

    @Test
    void updatePerson_replacesMatchingPersonById() {
        Person existingPerson = personService.getPersons().get(0);
        Person updatedPerson = new Person(existingPerson.getId(), "Mark", "Watney");

        personService.updatePerson(updatedPerson);

        List<Person> persons = personService.getPersons();
        assertEquals(2, persons.size());

        Person result = persons.stream()
                .filter(p -> p.getId().equals(existingPerson.getId()))
                .findFirst()
                .orElseThrow();

        assertEquals("Mark", result.getFirstName());
        assertEquals("Watney", result.getLastName());
    }

    @Test
    void removePerson_removesMatchingPersonById() {
        Person existingPerson = personService.getPersons().get(0);

        personService.removePerson(existingPerson);

        List<Person> persons = personService.getPersons();
        assertEquals(1, persons.size());
        assertFalse(persons.stream().anyMatch(p -> p.getId().equals(existingPerson.getId())));
    }
}
