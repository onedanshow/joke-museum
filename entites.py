import spacy

nlp = spacy.load("en_core_web_sm")

# Assuming you have a list of jokes
jokes = ["Did you hear about the Native American man that drank 200 cups of tea?","Did you hear about the oyster who went to the ball?","Shall I tell you the joke about the kidnappers?","Do you like fish sticks?","Want to hear a joke about UDP?"]

# Combine all jokes into one text
text = ' '.join(jokes)

# Process the text
doc = nlp(text)

# Extract named entities
print('Named entities:')
for ent in doc.ents:
  print("Entity: ",ent.text," Label: ", ent.label_, " Explanation: ", spacy.explain(ent.label_))


print("Noun phrases:", list(set(chunk.text for chunk in doc.noun_chunks)))
print("Verbs:", list(set(token.lemma_ for token in doc if token.pos_ == "VERB")))

# Extract words
# print('\nWords:')
# for token in doc:
#     print(token.text)