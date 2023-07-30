import spacy
import sys
import json

# Load Spacy model
nlp = spacy.load("en_core_web_sm")

# Stop words list
stop_words = spacy.lang.en.stop_words.STOP_WORDS

def lemmatize(word):
    """
    This function receives a word and returns its lemmatized version
    """
    doc = nlp(word)
    return ' '.join([token.lemma_ for token in doc if not token.is_stop])

def normalize(word):
    """
    This function removes stopwords from the word
    """
    doc = nlp(word)
    return ' '.join([token.text for token in doc if not token.is_stop])

# Get the text argument from command line
text = sys.argv[1]

# Process the text
doc = nlp(text)

# Extract entities, nouns, and verbs
entities = [normalize(ent.text) for ent in doc.ents]
nouns = [normalize(chunk.text) for chunk in doc.noun_chunks]
verbs = [normalize(token.lemma_) for token in doc if token.pos_ == "VERB"]

# Extract lemmatized entities, nouns, and verbs
lemmatized_entities = [lemmatize(ent) for ent in entities]
lemmatized_nouns = [lemmatize(noun) for noun in nouns]
lemmatized_verbs = [lemmatize(verb) for verb in verbs]

# Output results as JSON
print(json.dumps({
    "entities": entities, 
    "nouns": nouns, 
    "verbs": verbs, 
    "lemmatized_entities": lemmatized_entities, 
    "lemmatized_nouns": lemmatized_nouns, 
    "lemmatized_verbs": lemmatized_verbs
}))
