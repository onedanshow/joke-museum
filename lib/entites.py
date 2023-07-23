import spacy
import pandas as pd

nlp = spacy.load("en_core_web_sm")

# Increase the max_length 
nlp.max_length = 5000000

# Read CSV file
df = pd.read_csv('./lib/qajokes1.1.2-cleaned.csv')

# Filter rows where 'Dirty?' is not equal to 0
df = df[df['Dirty?'] == 0]

# Combine all questions and answers into one text
# Convert all items to string before joining
text = ' '.join(str(x) for x in df['Question'].tolist() + df['Answer'].tolist())

# Process the text
doc = nlp(text)

# Extract named entities, nouns, and verbs
entities = [(ent.text, ent.label_, spacy.explain(ent.label_)) for ent in doc.ents]
nouns = list(set(chunk.text for chunk in doc.noun_chunks))
verbs = list(set(token.lemma_ for token in doc if token.pos_ == "VERB"))

# Write to new CSV files
df_entities = pd.DataFrame(entities, columns=['Entity', 'Label', 'Explanation'])
df_entities.to_csv('entities.csv', index=False)

df_nouns = pd.DataFrame(nouns, columns=['Noun'])
df_nouns.to_csv('nouns.csv', index=False)

df_verbs = pd.DataFrame(verbs, columns=['Verb'])
df_verbs.to_csv('verbs.csv', index=False)