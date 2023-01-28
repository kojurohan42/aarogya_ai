from flask import Flask, request, jsonify
import werkzeug
import numpy as np
import cv2
import tensorflow as tf
import os
import PIL.ImageOps as ImageOps
import PIL.Image as Image
from keras.models import load_model
app = Flask(__name__)
class_names = ['Basale',
               'Guava',
               'Neem',
               'Sandalwood',
               'Tulsi']
# Models = np.array([load_model(os.path.join(Path, 'best_val_loss.hdf5'))
#                   for Path in ['Model_1', 'Model_2', 'Model_3']])
model = load_model('Model_1/best_val_loss.hdf5')


@app.route('/upload', methods=["POST"])
def upload():
    if(request.method == "POST"):
        imagefile = request.files['image']
        filename = werkzeug.utils.secure_filename(imagefile.filename)
        imagefile.save("./uploadedimages/" + filename)
        img = cv2.imread("./uploadedimages/" + filename)
        os.remove("./uploadedimages/" + filename)
        data = np.ndarray(shape=(1, 150, 150, 3), dtype=np.float32)
        size = (150, 150)
        image_PIL = Image.fromarray(img)
        image = ImageOps.fit(image_PIL, size, Image.ANTIALIAS)
        image_array = np.asarray(image)
        # Normalize the image
        normalized_image_array = (image_array.astype(np.float32) / 127.0) - 1

        # Load the image into the array
        data[0] = normalized_image_array

        # run the inference
        # prediction = np.array([np.argmax(Model.predict(data))
        #                       for Model in Models])
        prediction = model.predict(data)
        # We take the highest probability
        pred_label = np.argmax(prediction)
        # success =
        # success = prediction[pred_label]
        print(pred_label)

        # print(success)
        # if success > 0.9:
        class_prediction = class_names[pred_label]
        # else:
        #     class_prediction = "Unknown Plant"

        print(class_prediction)
        return jsonify({
            "message": class_prediction
        })


if __name__ == "__main__":
    app.run(debug=True, port=4000)
