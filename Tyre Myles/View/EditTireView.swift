//
//  DateSheetView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI
import CoreData

struct EditTireView: View {
	@Environment(\.dismiss) var dismiss
	
	@EnvironmentObject var model: CoreDataModel

	@FocusState private var focusedField: Field?

	@State private var installDate = Date()
	@State private var removalDate = Date()

	@State private var name = ""
	@State private var installMilage: Double = 0
	@State private var removalMilage: Double = 0
	@State private var seasonType: TyreModel.SeasonType = .allSeason
	@State private var tireStatus: TyreModel.TireStatus = .inStorage

	let currentTire: TireEntity

	// To determine whether mileage values have been changed.
	// If so, used in updating total tire mileage when in storage.
	var previousInstallMileage: Double
	var previousRemovalMilage: Double

	enum Field {
		case removal
	}

	var body: some View {
		ScrollView {

			VStack {
				Text("Edit Tyre")
					.font(.largeTitle)
				TextField(currentTire.name ?? "Name", text: $name, prompt: Text("Name"))
					.textFieldStyle(.roundedBorder)
				Picker("Season", selection: $seasonType) {
					Text("Summer")
						.tag(TyreModel.SeasonType.summer)
					Text("All Season")
						.tag(TyreModel.SeasonType.allSeason)
					Text("Winter")
						.tag(TyreModel.SeasonType.winter)
					Text("Track")
						.tag(TyreModel.SeasonType.track)
				}
				.padding([.leading, .trailing])
				.pickerStyle(.segmented)

				Text("Enter Date Values")
					.font(.headline)
					.padding()
				DatePicker("Install Date", selection: $installDate, displayedComponents: .date)

				Picker("Wheel Status", selection: $tireStatus) {
					Text("On Vehicle").tag(TyreModel.TireStatus.onVehicle)
					Text("In Storage").tag(TyreModel.TireStatus.inStorage)
				}.pickerStyle(.segmented)
					.onChange(of: tireStatus, perform: { newStatus in
						if newStatus == .inStorage {
							focusedField = nil
							removalMilage = 0
						}
					})
					.padding(.vertical)

				DatePicker("Removal Date", selection: $removalDate, in: installDate..., displayedComponents: .date)
					.opacity(tireStatus == .onVehicle ? 0.25 : 1.0)
					.disabled(tireStatus == .onVehicle)

				Text("Enter Mileage Values")
					.font(.headline)
					.padding()

				Group {
					TextField("Installation Mileage", value: $installMilage, format: .number)
					TextField("Removal Mileage", value: $removalMilage, format: .number)
						.focused($focusedField, equals: .removal)
				}
				.keyboardType(.numberPad)
				.textFieldStyle(.roundedBorder)

				HStack {
					Button(role: .cancel) {
						dismiss()
					} label: {
						Text("Cancel")
							.foregroundColor(.red)
					}.buttonStyle(.automatic)

					Button {
						saveEdit()
					} label: {
						Text("Save")
							.foregroundColor(.white)
					}
					.buttonStyle(.borderedProminent)
					.disabled(removalMilage == 0 && tireStatus == .inStorage)
					// Disabled to prevent poor UX logic.
					.padding()

					.alert("Mileage Entry Error", isPresented: $model.isPresentingAlert) {
						Button(role: .cancel) {
							// No action taken.
						} label: {
							Text("OK")
						}
					} message: {
						Text(ErrorMessage.negativeNumber)
					}
				}
			}.padding()
			.onAppear {
				loadInitialValues()
			}
		} // End ScrollView

	}

	private func loadInitialValues() {
		guard let loadedName = currentTire.name else { return }
		guard let loadedInstallDate = currentTire.installDate else { return }
		guard let loadedRemovalDate = currentTire.removalDate else { return }
		guard let loadedTireSeason = TyreModel.SeasonType(rawValue: currentTire.seasonType!) else { return }
		let loadedInstallMilage = currentTire.installMiles
		let loadedRemovalMilage = currentTire.removalMiles

		name = loadedName
		seasonType = loadedTireSeason
		tireStatus = loadingTire(status: currentTire.isInStorage)
		installDate = loadedInstallDate
		removalDate = loadedRemovalDate
		installMilage = loadedInstallMilage
		removalMilage = loadedRemovalMilage
	}

	private func saveEdit() {
		if mileageDidChange() && tireStatus == .inStorage {
			model.adjustTotalMilage(for: currentTire, adding: removalMilage - installMilage)
		}

		let editedTire = TyreModel(installMiles: installMilage, removalMiles: removalMilage, name: name, type: seasonType, status: tireStatus, installDate: installDate, removalDate: removalDate)

		model.editTire(entity: currentTire, with: editedTire)

		if !model.isPresentingAlert { dismiss() }
	}

	private func mileageDidChange() -> Bool {
		if previousInstallMileage == installMilage && previousRemovalMilage == removalMilage {
			return false
		} else {
			return true
		}
	}

	private func loadingTire(status: Bool) -> TyreModel.TireStatus {
		// To set value of Picker when loading Edit View.
		switch status {
			case true:
				return .inStorage
			case false:
				return .onVehicle
		}
	}

	private func editingTire(status: TyreModel.TireStatus) -> Bool {
		switch status {
			case .onVehicle:
				return false
			case .inStorage:
				return true
		}
	}

}

#if DEBUG
struct EditTireView_Previews: PreviewProvider {
    static var previews: some View {
		Text("Test View")
    }
}
#endif
