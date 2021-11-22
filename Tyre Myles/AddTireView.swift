//
//  NewTireView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/24/21.
//

import SwiftUI

struct AddTireView: View {
	enum Field {
		case name
		case install
		case removal
	}

	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var dataModel: DataModel

	@State private var name = ""
	@State private var seasonType: TireType = .allSeason
	@State private var tireStatus: TireStatus = .inStorage
	@State private var installDate = Date()
	@State private var removalDate = Date()
	@State private var installMiles = ""
	@State private var removalMiles = ""

	@FocusState private var focusedField: Field?

	// Save button outline.
	let linearGradient = LinearGradient(gradient: Gradient(colors: [.gray, .white, .gray]), startPoint: .top, endPoint: .bottom)


	var body: some View {
		ScrollView {

		VStack {
//			Text("Add New Tire")
//				.padding([.top, .leading])
//				.font(.title.bold())
			Picker("Season", selection: $seasonType) {
				Text("Summer")
					.tag(TireType.summer)
				Text("All Season")
					.tag(TireType.allSeason)
				Text("Winter")
					.tag(TireType.winter)
			}
			.padding([.leading, .trailing])
			.pickerStyle(.segmented)

			Group {
				TextField("Tire Name", text: $name)
					.focused($focusedField, equals: .name)
					.keyboardType(.alphabet)
					.submitLabel(.next)
					.padding(.top, 10)
				TextField("Install Mileage", text: $installMiles)
					.focused($focusedField, equals: .install)
					.keyboardType(.numbersAndPunctuation)
					.submitLabel(.next)
				TextField("Removal Mileage", text: $removalMiles)
					.focused($focusedField, equals: .removal)
					.keyboardType(.numbersAndPunctuation)
					.submitLabel(.done)
			}
			.textFieldStyle(.roundedBorder)
			.padding([.leading, .trailing])

			Group {
				Text("Enter Date Values")
					.font(.title2)
					.padding(.top, 40)
				DatePicker("Install Date", selection: $installDate, displayedComponents: .date)

				Picker("Wheel Status", selection: $tireStatus) {
					Text("On Vehicle").tag(TireStatus.onVehicle)
					Text("In Storage").tag(TireStatus.inStorage)
				}
				.pickerStyle(.segmented)
				.padding(.vertical)

				if tireStatus == .inStorage {
					DatePicker(selection: $removalDate, in: installDate..., displayedComponents: .date) { Text("Removal Date") }
				}
			}.padding(.horizontal)

			Spacer()

			SaveButton
		}

	}// End of ScrollView
		.navigationBarTitle(Text("Add New Tire"))


		.onSubmit {
			// move text focus to next field upon entry.
			switch focusedField {
				case .name:
					focusedField = .install
				case .install:
					focusedField = .removal
				case .removal:
					focusedField = nil
				case .none:
					focusedField = nil
			}
		}


	}


	private var SaveButton: some View {
		Button {
			save()
		} label: {
			Capsule()
				.stroke(linearGradient, lineWidth: 2)
				.frame(height: 50)
				.overlay(Text("Save")
							.font(.title.bold())
							.foregroundColor(.primary)
				)
		}
		.padding()
//		.padding(.horizontal, 40)
//		.padding(.bottom)
		.disabled(name.isEmpty)
		.opacity(name.isEmpty ? 0.25 : 1.0)
	}

	private func save() {
		dataModel.saveTireProfileWith(name: name, season: seasonType, status: tireStatus, installMiles: installMiles,
									  removalMiles: removalMiles, installDate: installDate,
									  removallDate: removalDate)

		dismiss()
	}

	private func cancel() {
		dismiss()
	}

}


#if DEBUG
struct NewTireView_Previews: PreviewProvider {

    static var previews: some View {
		AddTireView()
			.preferredColorScheme(.light)
    }
}
#endif
